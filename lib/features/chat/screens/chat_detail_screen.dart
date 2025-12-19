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
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class _PendingAttachment {
  final String name;
  final String type; // 'image' | 'file' | 'course' | 'booking'
  final Uint8List? bytes;
  final int? courseId;
  final int? bookingId;
  final int signature;

  const _PendingAttachment({
    required this.name,
    required this.type,
    this.bytes,
    this.courseId,
    this.bookingId,
    required this.signature,
  });

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

  bool _isLoading = true;
  bool _isSending = false;
  bool _didInitialOpenActions = false;
  Timer? _pollingTimer;
  ChatMessage? _replyToMessage;

  @override
  void initState() {
    super.initState();
    _addPendingPreSendAttachment(widget.preSendAttachment);
    _loadMessages();
    _startPolling();
    _setupScrollListener();
  }

  void _addPendingPreSendAttachment(PreSendAttachment? preSendAttachment) {
    if (preSendAttachment == null) return;

    final type = preSendAttachment.type;
    if (type != 'course' && type != 'booking') return;

    final signature = Object.hash('presend', type, preSendAttachment.id);
    final alreadyAdded = _pendingAttachments.any((a) => a.signature == signature);
    if (alreadyAdded) return;

    _pendingAttachments.add(
      _PendingAttachment(
        name: preSendAttachment.title ?? (type == 'course'
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
        _messages.clear();
        _messages.addAll(result['messages'] as List<ChatMessage>);
        _isLoading = false;
      });

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
        _showSnackBar(result['error'] ?? 'Failed to load messages', isError: true);
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
        _showSnackBar('Failed to send message (missing server response)', isError: true);
        return;
      }

      final toUpload = List<_PendingAttachment>.from(_pendingAttachments);
      setState(() {
        _replyToMessage = null;
        _pendingAttachments.clear();
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
      });

      await _loadMessages();
      _scrollToBottom();

      if (failedUploads > 0) {
        _showSnackBar('$failedUploads attachment(s) failed to upload', isError: true);
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

    final isMobile = !kIsWeb &&
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
                      _showSnackBar('Failed to open gallery: $e', isError: true);
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
                        _showSnackBar('Failed to read file bytes for ${f.name}', isError: true);
                        continue;
                      }

                      final ext = (f.extension ?? '').toLowerCase();
                      final isImage = <String>{'png', 'jpg', 'jpeg', 'gif', 'webp'}
                          .contains(ext);

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
      final alreadyAdded = _pendingAttachments.any((a) => a.signature == signature);
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: SizedBox(
        height: 74,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final att = _pendingAttachments[index];

            return Stack(
              children: [
                att.isEmbed
                    ? Container(
                        width: 170,
                        height: 74,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              att.type == 'course' ? Icons.school : Icons.calendar_today,
                              size: 22,
                              color: att.type == 'course' ? Colors.purple[600] : Colors.blue[600],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    att.type == 'course' ? 'Course' : 'Booking',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    att.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 74,
                        height: 74,
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
                                    return const Center(child: Icon(Icons.broken_image));
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.insert_drive_file, size: 24, color: Colors.grey),
                                      const SizedBox(height: 6),
                                      Text(
                                        att.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 10, color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: InkWell(
                    onTap: () => _removePendingAttachmentAt(index),
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 14, color: Colors.white),
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
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            ChatDetailsHeader(
              otherUser: widget.otherUser,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: _isLoading && _messages.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ChatList(
                      messages: _messages,
                      onReply: _handleReply,
                      scrollController: _scrollController,
                    ),
            ),
            if (_isSending)
              const LinearProgressIndicator(minHeight: 2),
            _buildPendingAttachmentsBar(),
            ChatInputBox(
              onSend: _sendMessage,
              initialText: widget.preSendMessage,
              replyTo: _replyToMessage,
              onClearReply: _clearReply,
              hasPendingAttachments: _pendingAttachments.isNotEmpty,
              onAttachment: _openAttachmentPicker,
            ),
          ],
        ),
      ),
    );
  }
}
