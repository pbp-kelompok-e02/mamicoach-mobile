import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mamicoach_mobile/core/constants/api_constants.dart';
import 'package:mamicoach_mobile/features/chat/models/chat_models.dart';
import 'package:mamicoach_mobile/features/chat/screens/chat_detail_screen.dart';
import 'package:mamicoach_mobile/features/chat/screens/chat_index_screen.dart';
import 'package:mamicoach_mobile/features/chat/services/chat_service.dart';

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  static const String _defaultChannelId = 'mamicoach_chat';
  static const String _defaultChannelName = 'Chat';
  static const String _defaultChannelDescription = 'Chat message notifications';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  GlobalKey<NavigatorState>? _navigatorKey;
  String? _pendingChatSessionId;

  Future<void> init({required GlobalKey<NavigatorState> navigatorKey}) async {
    if (_initialized) return;

    _navigatorKey = navigatorKey;

    await _initLocalNotifications();
    await _requestAndroid13NotificationPermission();

    // Receives messages when app is in foreground.
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Fires when user taps a notification and opens the app.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        print('[Push] onMessageOpenedApp data=${message.data}');
      }

      _handleNotificationData(message.data, source: 'onMessageOpenedApp');
    });

    // Handles messages that opened the app from a terminated state.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (kDebugMode && initialMessage != null) {
      print('[Push] getInitialMessage data=${initialMessage.data}');
    }
    if (initialMessage != null) {
      // App might not have a Navigator context yet; queue it and retry later.
      _handleNotificationData(initialMessage.data, source: 'getInitialMessage');
    }

    // Token refresh (can happen anytime).
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      if (kDebugMode) {
        print('[Push] onTokenRefresh token=$token');
      }
    });

    _initialized = true;

    if (kDebugMode) {
      final token = await FirebaseMessaging.instance.getToken();
      print('[Push] init complete token=$token');
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        try {
          final payload = response.payload;
          if (payload == null || payload.isEmpty) return;

          final decoded = jsonDecode(payload);
          if (decoded is! Map) return;

          final data = Map<String, dynamic>.from(decoded);
          if (kDebugMode) {
            print('[Push] local notification tap data=$data');
          }
          _handleNotificationData(data, source: 'localNotificationTap');
        } catch (e) {
          if (kDebugMode) {
            print('[Push] Failed to parse local notification payload: $e');
          }
        }
      },
    );

    const androidChannel = AndroidNotificationChannel(
      _defaultChannelId,
      _defaultChannelName,
      description: _defaultChannelDescription,
      importance: Importance.high,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(androidChannel);
  }

  Future<void> _requestAndroid13NotificationPermission() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    // On Android < 13 this is a no-op.
    final granted = await androidPlugin?.requestNotificationsPermission();
    if (kDebugMode) {
      print('[Push] Android notifications permission granted=$granted');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    // When app is in foreground, Android often doesn't display notifications.
    // We show a local notification for a consistent UX.
    final notification = message.notification;

    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if (kDebugMode) {
      print('[Push] onMessage title=$title body=$body data=${message.data}');
    }

    if (title == null && body == null) return;

    final payload = jsonEncode(message.data);

    _localNotifications.show(
      message.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _defaultChannelId,
          _defaultChannelName,
          channelDescription: _defaultChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: payload,
    );
  }

  Future<String?> getFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (kDebugMode) {
        print('[Push] getFcmToken token=$token');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get FCM token: $e');
      }
      return null;
    }
  }

  Future<void> registerTokenWithBackend(CookieRequest request) async {
    final token = await getFcmToken();
    if (token == null || token.isEmpty) {
      if (kDebugMode) {
        print('[Push] registerTokenWithBackend skipped: empty token');
      }
      return;
    }

    try {
      // pbp_django_auth's JSON helper can conflict with http's Request fields handling.
      // This endpoint accepts form-encoded too, so keep it simple.
      final resp = await request.post(
        '${ApiConstants.baseUrl}/auth/api_fcm_token/',
        {
          'token': token,
          'platform': 'android',
        },
      );

      if (kDebugMode) {
        print('[Push] backend token register response=$resp');
      }
    } catch (e) {
      // Non-fatal: push is an enhancement.
      if (kDebugMode) {
        print('Failed to register FCM token to backend: $e');
      }
    }
  }

  /// Best-effort: unregister this device token from the backend.
  ///
  /// Must be called while the user is still authenticated (i.e. BEFORE logout)
  /// because it uses the session cookie.
  Future<void> unregisterTokenWithBackend(CookieRequest request) async {
    final token = await getFcmToken();
    if (token == null || token.isEmpty) {
      if (kDebugMode) {
        print('[Push] unregisterTokenWithBackend skipped: empty token');
      }
      return;
    }

    try {
      final resp = await request.post(
        '${ApiConstants.baseUrl}/auth/api_fcm_token_delete/',
        {
          'token': token,
          'platform': 'android',
        },
      );

      if (kDebugMode) {
        print('[Push] backend token delete response=$resp');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to unregister FCM token from backend: $e');
      }
    }
  }

  /// Call this after app start/login to handle any pending notification tap.
  Future<void> tryHandlePendingNavigation() async {
    final sessionId = _pendingChatSessionId;
    if (sessionId == null || sessionId.isEmpty) return;
    await _openChatSession(sessionId);
  }

  void _handleNotificationData(
    Map<String, dynamic> data, {
    required String source,
  }) {
    final type = data['type']?.toString();
    final sessionId = data['session_id']?.toString();

    if (kDebugMode) {
      print('[Push] handleNotificationData source=$source type=$type session_id=$sessionId data=$data');
    }

    if (sessionId == null || sessionId.isEmpty) return;
    if (type != null && type.isNotEmpty && type != 'chat') return;

    _pendingChatSessionId = sessionId;
    // Best-effort immediate attempt.
    _openChatSession(sessionId);
  }

  Future<void> _openChatSession(String sessionId) async {
    final navigatorKey = _navigatorKey;
    if (navigatorKey == null) {
      _pendingChatSessionId = sessionId;
      return;
    }

    final context = navigatorKey.currentContext;
    if (context == null) {
      _pendingChatSessionId = sessionId;
      return;
    }

    final request = Provider.of<CookieRequest>(context, listen: false);
    if (request.loggedIn != true) {
      if (kDebugMode) {
        print('[Push] Not logged in yet; keeping pending session_id=$sessionId');
      }
      _pendingChatSessionId = sessionId;
      return;
    }

    try {
      final sessionsResp = await ChatService.getChatSessions(request: request);
      if (sessionsResp['success'] == true) {
        final sessions = (sessionsResp['sessions'] as List).cast<ChatSession>();
        final session = sessions
            .where((s) => s.id.toString() == sessionId.toString())
            .cast<ChatSession?>()
            .firstWhere((s) => s != null, orElse: () => null);

        if (session != null) {
          // This app's sessions payload already gives the "other" user.
          final ChatUser otherUser = session.user;

          _pendingChatSessionId = null;

          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => ChatDetailScreen(
                sessionId: sessionId,
                otherUser: otherUser,
              ),
            ),
          );
          return;
        }
      }

      // Fallback: open chat index screen; user can open the session manually.
      _pendingChatSessionId = null;
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const ChatIndexScreen()),
      );
    } catch (e) {
      if (kDebugMode) {
        print('[Push] Failed to open chat session from notification: $e');
      }
      _pendingChatSessionId = sessionId;
    }
  }
}
