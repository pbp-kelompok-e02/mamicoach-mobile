import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';
import 'package:mamicoach_mobile/features/chat/services/chat_service.dart';
import 'package:mamicoach_mobile/features/chat/widgets/chat_details_header.dart';
import 'package:mamicoach_mobile/features/chat/widgets/chat_list.dart';
import 'package:mamicoach_mobile/features/chat/widgets/chat_input_box.dart';
import 'package:mamicoach_mobile/widgets/sequence_loader.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class _PendingAttachment {
  final String name;
  final String type; // 'image' | 'file' | 'course' | 'booking'
  final Uint8List? bytes;
  final int? courseId;
  final int? bookingId;
  final int signature;
  final bool isUploading;

  const _PendingAttachment({
    required this.name,
    required this.type,
    this.bytes,
    this.courseId,
    this.bookingId,
    required this.signature,
    this.isUploading = false,
  });

  _PendingAttachment copyWith({bool? isUploading}) {
    return _PendingAttachment(
      name: name,
      type: type,
      bytes: bytes,
      courseId: courseId,
      bookingId: bookingId,
      signature: signature,
      isUploading: isUploading ?? this.isUploading,
    );
  }

  bool get isImage => type == 'image';
  bool get isFileUpload => type == 'image' || type == 'file';
  bool get isEmbed => type == 'course' || type == 'booking';
}

class ChatDetailScreen extends StatefulWidget {
  final String sessionId;
  final ChatUser otherUser;
  final String? preSendMessage;
  final PreSendAttachment? preSendAttachment;

  const ChatDetailScreen({
    super.key,
    required this.sessionId,
    required this.otherUser,
    this.preSendMessage,
    this.preSendAttachment,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final List<_PendingAttachment> _pendingAttachments = [];

  late ChatUser _headerOtherUser;
  int? _currentUserId;

  bool _isLoading = true;
  bool _isSending = false;
  bool _didInitialOpenActions = false;
  Timer? _pollingTimer;
  ChatMessage? _replyToMessage;

  @override
  void initState() {
    super.initState();
    _headerOtherUser = widget.otherUser;
    _addPendingPreSendAttachment(widget.preSendAttachment);
    _loadMessages();
    _startPolling();
    _setupScrollListener();
  }

  ChatUser _mergeUserPreferNonEmpty(ChatUser base, ChatUser incoming) {
    if (base.id != incoming.id) return incoming;

    final mergedProfile =
        (base.profileImageUrl != null &&
            base.profileImageUrl!.trim().isNotEmpty)
        ? base.profileImageUrl!.trim()
        : ((incoming.profileImageUrl != null &&
                  incoming.profileImageUrl!.trim().isNotEmpty)
              ? incoming.profileImageUrl!.trim()
              : null);

    final mergedUsername = base.username.trim().isNotEmpty
        ? base.username
        : incoming.username;

    final mergedFirstName = base.firstName.trim().isNotEmpty
        ? base.firstName
        : incoming.firstName;

    final mergedLastName = base.lastName.trim().isNotEmpty
        ? base.lastName
        : incoming.lastName;

    return ChatUser(
      id: base.id,
      username: mergedUsername,
      firstName: mergedFirstName,
      lastName: mergedLastName,
      profileImageUrl: mergedProfile,
    );
  }

  void _maybeResolveHeaderOtherUserFromMessages() {
    if (_messages.isEmpty) return;

    // Prefer server-provided current_user_id when available.
    final myId = _currentUserId;

    final counts = <int, int>{};
    final usersById = <int, ChatUser>{};

    for (final m in _messages) {
      final sender = m.sender;
      final senderId = sender.id;

      // If current user id is unknown, use isSentByMe as a hint.
      final isMe = myId != null ? senderId == myId : m.isSentByMe;
      if (isMe) continue;

      counts[senderId] = (counts[senderId] ?? 0) + 1;
      usersById[senderId] = sender;
    }

    if (counts.isEmpty) return;

    final bestId = counts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
    final resolved = usersById[bestId];
    if (resolved == null) return;

    setState(() {
      _headerOtherUser = _mergeUserPreferNonEmpty(_headerOtherUser, resolved);
    });
  }

  void _addPendingPreSendAttachment(PreSendAttachment? preSendAttachment) {
    if (preSendAttachment == null) return;

    final type = preSendAttachment.type;
    if (type != 'course' && type != 'booking') return;

    final signature = Object.hash('presend', type, preSendAttachment.id);
    final alreadyAdded = _pendingAttachments.any(
      (a) => a.signature == signature,
    );
    if (alreadyAdded) return;

    _pendingAttachments.add(
      _PendingAttachment(
        name:
            preSendAttachment.title ??
            (type == 'course'
                ? 'Course #${preSendAttachment.id}'
                : 'Booking #${preSendAttachment.id}'),
        type: type,
        courseId: type == 'course' ? preSendAttachment.id : null,
        bookingId: type == 'booking' ? preSendAttachment.id : null,
        signature: signature,
      ),
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _markMessagesAsRead();
      }
    });
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        _loadMessages(silent: true);
      }
    });
  }

  Future<void> _loadMessages({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
      });
    }

    final request = context.read<CookieRequest>();
    final result = await ChatService.getMessages(
      sessionId: widget.sessionId,
      request: request,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      setState(() {
        final currentUser = result['current_user_id'];
        _currentUserId = currentUser is num
            ? currentUser.toInt()
            : _currentUserId;
        _messages.clear();
        _messages.addAll(result['messages'] as List<ChatMessage>);
        _isLoading = false;
      });

      _maybeResolveHeaderOtherUserFromMessages();

      // Always run the initial open behavior once, even if the first
      // successful load comes from the polling path.
      if (!_didInitialOpenActions) {
        _didInitialOpenActions = true;
        _scrollToBottom(animated: false);
        _markMessagesAsRead();
      } else if (!silent) {
        _scrollToBottom();
        _markMessagesAsRead();
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (!silent) {
        _showSnackBar(
          result['error'] ?? 'Failed to load messages',
          isError: true,
        );
      }
    }
  }

  Future<void> _markMessagesAsRead() async {
    final request = context.read<CookieRequest>();
    await ChatService.markMessagesRead(
      sessionId: widget.sessionId,
      request: request,
    );
  }

  Future<void> _sendMessage(String content) async {
    if (_isSending) return;

    final trimmed = content.trim();
    if (trimmed.isEmpty && _pendingAttachments.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    final request = context.read<CookieRequest>();
    final result = await ChatService.sendMessage(
      sessionId: widget.sessionId,
      content: trimmed.isNotEmpty ? trimmed : '(lampiran)',
      replyToId: _replyToMessage?.id,
      request: request,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      final sentMessage = result['message'] as ChatMessage?;
      if (sentMessage == null) {
        setState(() {
          _isSending = false;
        });
        _showSnackBar(
          'Failed to send message (missing server response)',
          isError: true,
        );
        return;
      }

      final toUpload = List<_PendingAttachment>.from(_pendingAttachments);
      setState(() {
        _replyToMessage = null;
        for (var i = 0; i < _pendingAttachments.length; i++) {
          _pendingAttachments[i] = _pendingAttachments[i].copyWith(
            isUploading: true,
          );
        }
      });

      int failedUploads = 0;
      for (final att in toUpload) {
        if (att.isFileUpload) {
          final bytes = att.bytes;
          if (bytes == null) {
            failedUploads += 1;
            continue;
          }
          final uploadResult = await ChatService.uploadFileAttachment(
            sessionId: widget.sessionId,
            messageId: sentMessage.id,
            fileName: att.name,
            bytes: bytes,
            type: att.type,
            request: request,
          );
          if (uploadResult['success'] != true) {
            failedUploads += 1;
          }
        } else if (att.isEmbed) {
          final createResult = await ChatService.createAttachment(
            sessionId: widget.sessionId,
            messageId: sentMessage.id,
            type: att.type,
            courseId: att.courseId,
            bookingId: att.bookingId,
            request: request,
          );
          if (createResult['success'] != true) {
            failedUploads += 1;
          }
        }
      }

      setState(() {
        _isSending = false;
        _pendingAttachments.clear();
      });

      await _loadMessages();
      _scrollToBottom();

      if (failedUploads > 0) {
        _showSnackBar(
          '$failedUploads attachment(s) failed to upload',
          isError: true,
        );
      }
    } else {
      setState(() {
        _isSending = false;
      });
      _showSnackBar(result['error'] ?? 'Failed to send message', isError: true);
    }
  }

  Future<void> _openAttachmentPicker() async {
    if (_isSending) return;

    final isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isMobile)
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo from gallery'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    try {
                      final xfile = await _imagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (xfile == null) return;
                      final bytes = await xfile.readAsBytes();
                      _addPendingAttachment(
                        name: xfile.name,
                        type: 'image',
                        bytes: bytes,
                      );
                    } catch (e) {
                      _showSnackBar(
                        'Failed to open gallery: $e',
                        isError: true,
                      );
                    }
                  },
                ),
              if (isMobile)
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take a photo'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    try {
                      final xfile = await _imagePicker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (xfile == null) return;
                      final bytes = await xfile.readAsBytes();
                      _addPendingAttachment(
                        name: xfile.name,
                        type: 'image',
                        bytes: bytes,
                      );
                    } catch (e) {
                      _showSnackBar('Failed to open camera: $e', isError: true);
                    }
                  },
                ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('File'),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final result = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      withData: true,
                    );
                    if (result == null) return;

                    for (final f in result.files) {
                      final bytes = f.bytes;
                      if (bytes == null) {
                        _showSnackBar(
                          'Failed to read file bytes for ${f.name}',
                          isError: true,
                        );
                        continue;
                      }

                      final ext = (f.extension ?? '').toLowerCase();
                      final isImage = <String>{
                        'png',
                        'jpg',
                        'jpeg',
                        'gif',
                        'webp',
                      }.contains(ext);

                      _addPendingAttachment(
                        name: f.name,
                        type: isImage ? 'image' : 'file',
                        bytes: bytes,
                      );
                    }
                  } catch (e) {
                    _showSnackBar('Failed to pick file: $e', isError: true);
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _addPendingAttachment({
    required String name,
    required String type,
    required Uint8List bytes,
  }) {
    final signature = Object.hash(
      name,
      bytes.length,
      bytes.isNotEmpty ? bytes[0] : 0,
      bytes.length > 1 ? bytes[1] : 0,
    );

    setState(() {
      final alreadyAdded = _pendingAttachments.any(
        (a) => a.signature == signature,
      );
      if (alreadyAdded) return;
      _pendingAttachments.add(
        _PendingAttachment(
          name: name,
          type: type,
          bytes: bytes,
          signature: signature,
        ),
      );
    });
  }

  void _removePendingAttachmentAt(int index) {
    setState(() {
      if (index < 0 || index >= _pendingAttachments.length) return;
      _pendingAttachments.removeAt(index);
    });
  }

  Widget _buildPendingAttachmentsBar() {
    if (_pendingAttachments.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: SizedBox(
        height: 62,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final att = _pendingAttachments[index];

            return Stack(
              children: [
                att.isEmbed
                    ? Container(
                        width: 160,
                        height: 62,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              att.type == 'course'
                                  ? Icons.school
                                  : Icons.calendar_today,
                              size: 20,
                              color: att.type == 'course'
                                  ? Colors.purple[600]
                                  : Colors.blue[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    att.type == 'course' ? 'Course' : 'Booking',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    att.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: att.isImage
                              ? Image.memory(
                                  att.bytes!,
                                  fit: BoxFit.cover,
                                  gaplessPlayback: true,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.broken_image),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.insert_drive_file,
                                        size: 24,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        att.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                if (!att.isUploading)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: InkWell(
                      onTap: () => _removePendingAttachmentAt(index),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                if (att.isUploading)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.black26,
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemCount: _pendingAttachments.length,
        ),
      ),
    );
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final target = _scrollController.position.maxScrollExtent;
        if (animated) {
          _scrollController.animateTo(
            target,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(target);
        }
      }
    });
  }

  void _handleReply(ChatMessage message) {
    setState(() {
      _replyToMessage = message;
    });
  }

  void _clearReply() {
    setState(() {
      _replyToMessage = null;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Putting the header in the appBar guarantees it always renders above
      // the scrolling message list (no chat bubble can paint over it).
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: ChatDetailsHeader(
          otherUser: _headerOtherUser,
          onBack: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading && _messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ChatList(
                    messages: _messages,
                    onReply: _handleReply,
                    scrollController: _scrollController,
                  ),
          ),
          const Divider(height: 1),
          if (_isSending) const LinearProgressIndicator(minHeight: 2),
          _buildPendingAttachmentsBar(),
          ChatInputBox(
            onSend: _sendMessage,
            initialText: widget.preSendMessage,
            replyTo: _replyToMessage,
            onClearReply: _clearReply,
            hasPendingAttachments: _pendingAttachments.isNotEmpty,
            isSending: _isSending,
            onAttachment: _openAttachmentPicker,
          ),
        ],
      ),
    );
  }
}
