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
      final response = await super.get(url).timeout(
        const Duration(seconds: 5),
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
      final response = await super.post(url, data).timeout(
        const Duration(seconds: 5),
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
      final response = await super.postJson(url, data).timeout(
        const Duration(seconds: 5),
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
    
    // Network errors / server unreachable
    if (errorString.contains("socketexception") ||
        errorString.contains("clientexception") ||
        errorString.contains("connection") ||
        errorString.contains("failed host lookup") ||
        errorString.contains("network") ||
        errorString.contains("timeout") ||
        errorString.contains("timed out")) {
      // Navigate on next frame to avoid interrupting current build
      Future.microtask(() => _handleServerError());
      throw Exception("Server tidak dapat dijangkau");
    }
    
    // HTTP 500 errors
    if (errorString.contains("500") ||
        errorString.contains("internal server error")) {
      Future.microtask(() => _handleServerError());
      throw Exception("Terjadi kesalahan pada server");
    }
    
    // Other errors - throw as-is
    throw e;
  }

  dynamic _checkResponse(dynamic response) {
    if (response is Map) {
      // Check for explicit error fields if your API uses them
      if (response.containsKey('status')) {
        if (response['status'] == 401) {
          _handleUnauthorized();
        } else if (response['status'] == 500) {
          _handleServerError();
        }
      }
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

  void _handleServerError() {
    print("Server error detected. Showing 500 error page...");
    navigatorKey.currentState?.pushNamed(ServerError500Page.routeName);
  }
}
