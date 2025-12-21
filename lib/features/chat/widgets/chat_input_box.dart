import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';

class ChatInputBox extends StatefulWidget {
  final Future<void> Function(String) onSend;
  final VoidCallback? onAttachment;
  final bool hasPendingAttachments;
  final bool isSending;
  final String? initialText;
  final ChatMessage? replyTo;
  final VoidCallback? onClearReply;

  const ChatInputBox({
    super.key,
    required this.onSend,
    this.onAttachment,
    this.hasPendingAttachments = false,
    this.isSending = false,
    this.initialText,
    this.replyTo,
    this.onClearReply,
  });

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox> {
  final TextEditingController _controller = TextEditingController();
  bool _canSend = false;
  bool _didApplyInitialText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateSendButton);

    final initial = widget.initialText;
    if (initial != null && initial.trim().isNotEmpty) {
      _didApplyInitialText = true;
      _controller.text = initial;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      _canSend =
          !widget.isSending &&
          (_controller.text.trim().isNotEmpty || widget.hasPendingAttachments);
    }
  }

  @override
  void didUpdateWidget(covariant ChatInputBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hasPendingAttachments != widget.hasPendingAttachments) {
      _updateSendButton();
    }

    if (oldWidget.isSending != widget.isSending) {
      _updateSendButton();
    }

    // Apply initialText only once and only when the input is still empty.
    if (!_didApplyInitialText && oldWidget.initialText != widget.initialText) {
      final initial = widget.initialText;
      if ((_controller.text.trim().isEmpty) &&
          initial != null &&
          initial.trim().isNotEmpty) {
        _didApplyInitialText = true;
        _controller.text = initial;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        _updateSendButton();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSendButton() {
    setState(() {
      _canSend =
          !widget.isSending &&
          (_controller.text.trim().isNotEmpty || widget.hasPendingAttachments);
    });
  }

  Future<void> _handleSend() async {
    if (widget.isSending) return;
    final text = _controller.text.trim();
    if (text.isNotEmpty || widget.hasPendingAttachments) {
      await widget.onSend(text);
      if (!mounted) return;
      _controller.clear();
      setState(() {
        _canSend = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.replyTo != null) _buildReplyBanner(),
            Row(
              children: [
                if (widget.onAttachment != null)
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: widget.isSending ? null : widget.onAttachment,
                    color: Colors.grey[600],
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints.tightFor(
                      width: 40,
                      height: 40,
                    ),
                  ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    maxLines: 5,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: _canSend
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _canSend ? _handleSend : null,
                    color: Colors.white,
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints.tightFor(
                      width: 44,
                      height: 44,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: Theme.of(context).primaryColor, width: 3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to ${widget.replyTo!.sender.displayName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.replyTo!.content,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: widget.onClearReply,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
