import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mamicoach_mobile/screens/login_page.dart';
import 'package:mamicoach_mobile/screens/errors/server_error_500_page.dart';

class AuthCookieRequest extends CookieRequest {
  final GlobalKey<NavigatorState> navigatorKey;

  AuthCookieRequest(this.navigatorKey);

  @override
  Future<dynamic> get(String url) async {
    try {
      final response = await super
          .get(url)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Connection timed out'),
          );
      return _checkResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> post(String url, dynamic data) async {
    try {
      final response = await super
          .post(url, data)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Connection timed out'),
          );
      return _checkResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<dynamic> postJson(String url, dynamic data) async {
    try {
      final response = await super
          .postJson(url, data)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Connection timed out'),
          );
      return _checkResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  dynamic _handleError(dynamic e) {
    final errorString = e.toString().toLowerCase();

    // Session expired / unauthorized
    if (errorString.contains("formatexception") ||
        errorString.contains("unexpected character")) {
      _handleUnauthorized();
      throw Exception("Session expired. Please login again.");
    }

    // HTTP 500 errors (server is down) - redirect to 500 page
    if (errorString.contains("500") ||
        errorString.contains("502") ||
        errorString.contains("503") ||
        errorString.contains("internal server error")) {
      Future.microtask(() => _handleServerError());
      throw Exception("Terjadi kesalahan pada server");
    }

    // All other errors (network, timeout, etc.) - just throw
    // Let individual pages handle with their own error UI (CommonErrorWidget)
    throw e;
  }

  dynamic _checkResponse(dynamic response) {
    if (response is Map) {
      // Check for explicit error status
      if (response.containsKey('status')) {
        if (response['status'] == 401) {
          _handleUnauthorized();
        } else if (response['status'] == 500 || response['status'] >= 500) {
          _handleServerError();
          throw Exception(response['error'] ?? 'Server error');
        }
      }

      // Check for error key in response (common pattern for 500 errors)
      // If response has 'error' key but no 'success' key, treat as server error
      if (response.containsKey('error') && !response.containsKey('success')) {
        Future.microtask(() => _handleServerError());
        throw Exception(response['error'] ?? 'Server error');
      }
    }
    return response;
  }

  void _handleUnauthorized() {
    print("Unauthorized access detected. Redirecting to login...");

    // Use the navigator key to push Login Page
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _handleServerError() {
    print("Server error detected. Showing 500 error page...");
    navigatorKey.currentState?.pushNamed(ServerError500Page.routeName);
  }
}
