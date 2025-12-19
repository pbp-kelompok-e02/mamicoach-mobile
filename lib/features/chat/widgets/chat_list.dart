import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';
import 'package:mamicoach_mobile/features/chat/widgets/chat_bubble.dart';

class ChatList extends StatefulWidget {
  final List<ChatMessage> messages;
  final Function(ChatMessage) onReply;
  final ScrollController? scrollController;

  const ChatList({
    super.key,
    required this.messages,
    required this.onReply,
    this.scrollController,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return const Center(
        child: Text(
          'No messages yet',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        return ChatBubble(
          message: message,
          onReply: () => widget.onReply(message),
        );
      },
    );
  }
}
