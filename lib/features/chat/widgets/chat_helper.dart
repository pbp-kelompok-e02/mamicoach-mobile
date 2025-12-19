import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';
import 'package:mamicoach_mobile/features/chat/screens/chat_detail_screen.dart';
import 'package:mamicoach_mobile/features/chat/services/chat_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ChatHelper {
  static Future<void> startChatWithCoach({
    required BuildContext context,
    required int coachId,
    required String coachName,
    String? preSendMessage,
    PreSendAttachment? preSendAttachment,
  }) async {
    final request = context.read<CookieRequest>();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final result = await ChatService.createChatWithCoach(
      coachId: coachId,
      request: request,
    );

    if (!context.mounted) return;
    
    Navigator.pop(context);

    if (result['success'] == true) {
      final nameParts = coachName.split(' ');
      final otherUser = ChatUser(
        id: coachId,
        username: coachName.toLowerCase().replaceAll(' ', '_'),
        firstName: nameParts.first,
        lastName: nameParts.skip(1).join(' '),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailScreen(
            sessionId: result['session_id'],
            otherUser: otherUser,
            preSendMessage: preSendMessage,
            preSendAttachment: preSendAttachment,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Failed to start chat'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static Widget buildChatButton({
    required BuildContext context,
    required int coachId,
    required String coachName,
    IconData icon = Icons.chat,
    String label = 'Chat',
    bool isIconOnly = false,
    String? preSendMessage,
    PreSendAttachment? preSendAttachment,
  }) {
    return isIconOnly
        ? IconButton(
            icon: Icon(icon),
            onPressed: () => startChatWithCoach(
              context: context,
              coachId: coachId,
              coachName: coachName,
              preSendMessage: preSendMessage,
              preSendAttachment: preSendAttachment,
            ),
            tooltip: label,
          )
        : ElevatedButton.icon(
            onPressed: () => startChatWithCoach(
              context: context,
              coachId: coachId,
              coachName: coachName,
              preSendMessage: preSendMessage,
              preSendAttachment: preSendAttachment,
            ),
            icon: Icon(icon),
            label: Text(label),
          );
  }

  static Widget buildChatFloatingButton({
    required BuildContext context,
    required int coachId,
    required String coachName,
    String? preSendMessage,
    PreSendAttachment? preSendAttachment,
  }) {
    return FloatingActionButton(
      onPressed: () => startChatWithCoach(
        context: context,
        coachId: coachId,
        coachName: coachName,
        preSendMessage: preSendMessage,
        preSendAttachment: preSendAttachment,
      ),
      child: const Icon(Icons.chat),
    );
  }
}
