import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mamicoach_mobile/core/constants/api_constants.dart';
import 'package:mamicoach_mobile/core/network/http_client_factory.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ChatService {
  static Future<Map<String, dynamic>> getChatSessions({
    required CookieRequest request,
  }) async {
    try {
      final response = await request.get('${ApiConstants.baseUrl}/chat/api/sessions/');

      if (response['sessions'] != null) {
        final sessionsRaw = response['sessions'] as List;
        final sessions = sessionsRaw.map((s) {
          final otherUser = s['other_user'];
          final lastMsg = s['last_message'];
          
          return {
            'id': s['id'],
            'user': otherUser,
            'coach': otherUser,
            'started_at': lastMsg['timestamp'],
            'last_message_at': lastMsg['timestamp'],
            'last_message': {
              'id': 0,
              'content': lastMsg['content'],
              'timestamp': lastMsg['timestamp'],
              'sender': otherUser,
              'is_sent_by_me': lastMsg['sender_is_me'],
              'read': lastMsg['is_read'],
              'attachments': [],
            },
            'unread_count': s['unread_count'],
          };
        }).map((s) => ChatSession.fromJson(s)).toList();
        
        return {'success': true, 'sessions': sessions};
      }
      
      return {
        'success': false,
        'error': response['error'] ?? 'Failed to fetch chat sessions',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getMessages({
    required String sessionId,
    required CookieRequest request,
  }) async {
    try {
      final response = await request.get(
        '${ApiConstants.baseUrl}/chat/api/$sessionId/messages/',
      );

      if (response['messages'] != null) {
        final messages = (response['messages'] as List)
            .map((m) => ChatMessage.fromJson(m))
            .toList();
        
        return {
          'success': true,
          'messages': messages,
          'current_user_id': response['current_user_id'],
        };
      }
      
      return {
        'success': false,
        'error': response['error'] ?? 'Failed to fetch messages',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> sendMessage({
    required String sessionId,
    required String content,
    int? replyToId,
    required CookieRequest request,
  }) async {
    try {
      final response = await request.postJson(
        '${ApiConstants.baseUrl}/chat/api/send/',
        jsonEncode({
          'session_id': sessionId,
          'content': content,
          if (replyToId != null) 'reply_to_id': replyToId,
        }),
      );

      if (response['success'] == true) {
        final message = response['message'] != null 
            ? ChatMessage.fromJson(response['message']) 
            : null;
        
        return {'success': true, 'message': message};
      }
      
      return {
        'success': false,
        'error': response['error'] ?? 'Failed to send message',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> markMessagesRead({
    required String sessionId,
    required CookieRequest request,
  }) async {
    try {
      final response = await request.postJson(
        '${ApiConstants.baseUrl}/chat/api/mark-read/',
        jsonEncode({'session_id': sessionId}),
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'updated_count': response['updated_count'] ?? 0,
        };
      }
      
      return {
        'success': false,
        'error': response['error'] ?? 'Failed to mark messages as read',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> createChatWithCoach({
    required int coachId,
    required CookieRequest request,
  }) async {
    try {
      final response = await request.post(
        '${ApiConstants.baseUrl}/chat/api/create-chat-with-coach/$coachId/',
        {},
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'session_id': response['session_id'],
          'message': response['message'] ?? 'Chat session created',
        };
      }
      
      return {
        'success': false,
        'error': response['error'] ?? 'Failed to create chat session',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> createChatWithUser({
    required int userId,
    required CookieRequest request,
  }) async {
    try {
      final response = await request.post(
        '${ApiConstants.baseUrl}/chat/api/create-chat-with-user/$userId/',
        {},
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'session_id': response['session_id'],
          'other_user': response['other_user'],
          'message': response['message'] ?? 'Chat session created',
        };
      }

      return {
        'success': false,
        'error': response['error'] ?? 'Failed to create chat session',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> createAttachment({
    required String sessionId,
    required int messageId,
    required String type,
    int? courseId,
    int? bookingId,
    required CookieRequest request,
  }) async {
    try {
      final response = await request.postJson(
        '${ApiConstants.baseUrl}/chat/api/$sessionId/create-attachment/',
        jsonEncode({
          'message_id': messageId,
          'type': type,
          if (courseId != null) 'course_id': courseId,
          if (bookingId != null) 'booking_id': bookingId,
        }),
      );

      if (response['success'] == true) {
        final attachment = response['attachment'] != null 
            ? ChatAttachment.fromJson(response['attachment']) 
            : null;
        
        return {'success': true, 'attachment': attachment};
      }
      
      return {
        'success': false,
        'error': response['error'] ?? 'Failed to create attachment',
      };
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> uploadFileAttachment({
    required String sessionId,
    required int messageId,
    required String fileName,
    required Uint8List bytes,
    String type = 'file',
    required CookieRequest request,
  }) async {
    http.Client? client;
    try {
      final url = '${ApiConstants.baseUrl}/chat/api/$sessionId/upload/';
      if (bytes.length > 10 * 1024 * 1024) {
        return {'success': false, 'error': 'File size exceeds 10MB limit'};
      }

      final req = http.MultipartRequest('POST', Uri.parse(url));

      // CookieRequest already maintains the correct cookie header.
      // `request.cookies` is Map<String, Cookie> (NOT String values), so serializing it
      // creates an invalid header like `sessionid=Instance of 'Cookie'`.
      final cookieHeader = request.headers['cookie'] ?? request.headers['Cookie'];
      if (cookieHeader != null && cookieHeader.isNotEmpty) {
        req.headers['cookie'] = cookieHeader;
      }

      client = createHttpClient();

      req.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
        ),
      );
      req.fields['message_id'] = messageId.toString();
      req.fields['type'] = type;

      final streamedResponse = await client.send(req);
      final response = await http.Response.fromStream(streamedResponse);
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'] == true) {
        final attachment = jsonResponse['attachment'] != null 
            ? ChatAttachment.fromJson(jsonResponse['attachment']) 
            : null;
        
        return {'success': true, 'attachment': attachment};
      }
      
      return {
        'success': false,
        'error': jsonResponse['error'] ?? 'Failed to upload attachment',
      };
    } catch (e) {
      return {'success': false, 'error': 'Upload error: ${e.toString()}'};
    } finally {
      client?.close();
    }
  }
}
