import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mamicoach_mobile/screens/login_page.dart';

class AuthCookieRequest extends CookieRequest {
  final GlobalKey<NavigatorState> navigatorKey;

  AuthCookieRequest(this.navigatorKey);

  @override
  Future<dynamic> get(String url) async {
    try {
      final response = await super.get(url);
      return _checkResponse(response);
    } catch (e) {
      if (e.toString().contains("FormatException") ||
          e.toString().contains("Unexpected character")) {
        // Likely received HTML (login page) instead of JSON
        _handleUnauthorized();
        throw Exception("Session expired. Please login again.");
      }
      rethrow;
    }
  }

  @override
  Future<dynamic> post(String url, dynamic data) async {
    try {
      final response = await super.post(url, data);
      return _checkResponse(response);
    } catch (e) {
      if (e.toString().contains("FormatException") ||
          e.toString().contains("Unexpected character")) {
        _handleUnauthorized();
        throw Exception("Session expired. Please login again.");
      }
      rethrow;
    }
  }

  @override
  Future<dynamic> postJson(String url, dynamic data) async {
    try {
      final response = await super.postJson(url, data);
      return _checkResponse(response);
    } catch (e) {
      if (e.toString().contains("FormatException") ||
          e.toString().contains("Unexpected character")) {
        _handleUnauthorized();
        throw Exception("Session expired. Please login again.");
      }
      rethrow;
    }
  }

  dynamic _checkResponse(dynamic response) {
    if (response is Map) {
      // Check for explicit error fields if your API uses them
      if (response.containsKey('status') && response['status'] == 401) {
        _handleUnauthorized();
      }
      // Also check if 'error' key exists and usually impliesauth error?
      // Depends on API, but let's be safe.
    }
    return response;
  }

  void _handleUnauthorized() {
    print("Unauthorized access detected. Redirecting to login...");

    // Clear session if needed
    // this.logout(...) // CookieRequest logout might fail if we are already messed up, but nice to try.

    // Use the navigator key to push Login Page
    if (navigatorKey.currentState != null) {
      // Avoid redirecting if already on login page?
      // Hard to detect route verification easily without route names,
      // but pushReplacement is generally safe.
      navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

      // Show snackbar? context is hard to get here without passing it.
      // We can use a global scaffold messenger key if we had one.
    }
  }
}
