import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';
import 'package:mamicoach_mobile/features/chat/services/chat_service.dart';
import 'package:mamicoach_mobile/features/chat/widgets/chat_details_header.dart';
import 'package:mamicoach_mobile/features/chat/widgets/chat_list.dart';
import 'package:mamicoach_mobile/features/chat/widgets/chat_input_box.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final String sessionId;
  final ChatUser otherUser;

  const ChatDetailScreen({
    super.key,
    required this.sessionId,
    required this.otherUser,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isSending = false;
  Timer? _pollingTimer;
  ChatMessage? _replyToMessage;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _startPolling();
    _setupScrollListener();
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

      if (!silent) {
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

    setState(() {
      _isSending = true;
    });

    final request = context.read<CookieRequest>();
    final result = await ChatService.sendMessage(
      sessionId: widget.sessionId,
      content: content,
      replyToId: _replyToMessage?.id,
      request: request,
    );

    if (!mounted) return;

    setState(() {
      _isSending = false;
    });

    if (result['success'] == true) {
      setState(() {
        _replyToMessage = null;
      });
      await _loadMessages();
      _scrollToBottom();
    } else {
      _showSnackBar(result['error'] ?? 'Failed to send message', isError: true);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
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
            ChatInputBox(
              onSend: _sendMessage,
              replyTo: _replyToMessage,
              onClearReply: _clearReply,
              onAttachment: () {
                _showSnackBar('Attachment feature coming soon!');
              },
            ),
          ],
        ),
      ),
    );
  }
}
