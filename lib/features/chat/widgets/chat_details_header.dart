import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';

class ChatDetailsHeader extends StatelessWidget {
  final ChatUser otherUser;
  final VoidCallback? onBack;

  const ChatDetailsHeader({
    super.key,
    required this.otherUser,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (onBack != null)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (onBack != null) const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: otherUser.profileImageUrl != null
                  ? NetworkImage(otherUser.profileImageUrl!)
                  : null,
              child: otherUser.profileImageUrl == null
                  ? Text(
                      _getInitials(otherUser),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUser.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '@${otherUser.username}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(ChatUser user) {
    final firstName = user.firstName.isNotEmpty ? user.firstName[0] : '';
    final lastName = user.lastName.isNotEmpty ? user.lastName[0] : '';
    return (firstName + lastName).toUpperCase();
  }
}
