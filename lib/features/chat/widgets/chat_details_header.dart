import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';
import 'package:mamicoach_mobile/core/widgets/proxy_network_image.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final imageUrl = (otherUser.profileImageUrl != null &&
            otherUser.profileImageUrl!.trim().isNotEmpty)
        ? otherUser.profileImageUrl!.trim()
        : null;

    return Material(
      color: colorScheme.surface,
      elevation: 1,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (onBack != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Back',
                ),
              if (onBack != null) const SizedBox(width: 12),
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary,
                backgroundImage:
                    imageUrl != null ? proxyNetworkImageProvider(imageUrl) : null,
                child: imageUrl == null
                    ? Text(
                        _getInitials(otherUser),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      otherUser.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      otherUser.username.isNotEmpty ? '@${otherUser.username}' : '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(ChatUser user) {
    final firstName = user.firstName.trim();
    final lastName = user.lastName.trim();

    final firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0] : '';
    final combined = (firstInitial + lastInitial).toUpperCase();
    if (combined.isNotEmpty) return combined;

    final username = user.username.trim();
    if (username.isNotEmpty) return username[0].toUpperCase();
    return '?';
  }
}
