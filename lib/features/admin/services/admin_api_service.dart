import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_constants.dart';

/// Admin API Service for MamiCoach Admin Panel
/// Handles all HTTP requests to the admin API endpoints with JWT authentication
class AdminApiService {
  static final AdminApiService _instance = AdminApiService._internal();
  factory AdminApiService() => _instance;
  AdminApiService._internal();

  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  /// Get authorization headers with Bearer token
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  /// Check if access token is valid
  bool get isAuthenticated => _accessToken != null && !_isTokenExpired;

  /// Check if token is expired
  bool get _isTokenExpired {
    if (_tokenExpiry == null) return true;
    return DateTime.now().isAfter(_tokenExpiry!.subtract(const Duration(minutes: 5)));
  }

  /// Set tokens after login
  void setTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
  }

  /// Get current access token
  String? get accessToken => _accessToken;

  /// Get current refresh token
  String? get refreshToken => _refreshToken;

  /// Load tokens from local storage
  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('admin_access_token');
    _refreshToken = prefs.getString('admin_refresh_token');
    final expiryStr = prefs.getString('admin_token_expiry');
    if (expiryStr != null) {
      _tokenExpiry = DateTime.tryParse(expiryStr);
    }
  }

  /// Save tokens to local storage
  Future<void> saveTokens() async {
    final prefs = await SharedPreferences.getInstance();
    if (_accessToken != null) {
      await prefs.setString('admin_access_token', _accessToken!);
    }
    if (_refreshToken != null) {
      await prefs.setString('admin_refresh_token', _refreshToken!);
    }
    if (_tokenExpiry != null) {
      await prefs.setString('admin_token_expiry', _tokenExpiry!.toIso8601String());
    }
  }

  /// Clear tokens from local storage
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_access_token');
    await prefs.remove('admin_refresh_token');
    await prefs.remove('admin_token_expiry');
  }

  /// Refresh access token using refresh token
  Future<bool> refreshAccessToken() async {
    if (_refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminRefresh}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': _refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == true) {
          _accessToken = data['data']['access_token'];
          _tokenExpiry = DateTime.now().add(
            Duration(seconds: data['data']['expires_in'] ?? ApiConstants.accessTokenExpirySeconds),
          );
          await saveTokens();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Refresh token error: $e');
      return false;
    }
  }

  /// Make authenticated request with auto token refresh
  Future<http.Response> _authenticatedRequest(
    Future<http.Response> Function() request,
  ) async {
    // Check if token needs refresh
    if (_isTokenExpired && _refreshToken != null) {
      final refreshed = await refreshAccessToken();
      if (!refreshed) {
        throw Exception('Session expired. Please login again.');
      }
    }
    
    return await request();
  }

  // ==================== AUTHENTICATION ====================

  /// Login admin user
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminLogin}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (response.statusCode == 200 && data['status'] == true) {
        // Save JWT tokens
        final tokenData = data['data'];
        setTokens(
          accessToken: tokenData['access_token'],
          refreshToken: tokenData['refresh_token'],
          expiresIn: tokenData['expires_in'] ?? ApiConstants.accessTokenExpirySeconds,
        );
        await saveTokens();
      }
      
      return data;
    } catch (e) {
      debugPrint('Login error: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }

  /// Logout admin user
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminLogout}'),
        headers: _headers,
      );

      await clearTokens();
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      
      return {'status': true, 'message': 'Logout successful'};
    } catch (e) {
      debugPrint('Logout error: $e');
      await clearTokens();
      return {'status': true, 'message': 'Logged out locally'};
    }
  }

  // ==================== DASHBOARD ====================

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _authenticatedRequest(() => 
        http.get(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminDashboard}'),
          headers: _headers,
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        return {'status': false, 'message': 'Authentication required'};
      }
      
      return {'status': false, 'message': 'Failed to fetch dashboard stats'};
    } catch (e) {
      debugPrint('Dashboard stats error: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }

  // ==================== BOOKINGS ====================

  /// Get list of bookings with optional filtering and pagination
  Future<Map<String, dynamic>> getBookings({
    String status = 'all',
    String? search,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'status': status,
        'page': page.toString(),
        'per_page': perPage.toString(),
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminBookings}')
          .replace(queryParameters: queryParams);

      final response = await _authenticatedRequest(() => 
        http.get(uri, headers: _headers),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        return {'status': false, 'message': 'Authentication required'};
      }
      
      return {'status': false, 'message': 'Failed to fetch bookings'};
    } catch (e) {
      debugPrint('Get bookings error: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }

  /// Get booking detail by ID
  Future<Map<String, dynamic>> getBookingDetail(int bookingId) async {
    try {
      final response = await _authenticatedRequest(() => 
        http.get(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminBookingDetail(bookingId)}'),
          headers: _headers,
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        return {'status': false, 'message': 'Booking not found'};
      } else if (response.statusCode == 401) {
        return {'status': false, 'message': 'Authentication required'};
      }
      
      return {'status': false, 'message': 'Failed to fetch booking detail'};
    } catch (e) {
      debugPrint('Get booking detail error: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }

  /// Update booking status
  Future<Map<String, dynamic>> updateBookingStatus(int bookingId, String newStatus) async {
    try {
      final response = await _authenticatedRequest(() => 
        http.post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminBookingUpdateStatus(bookingId)}'),
          headers: _headers,
          body: jsonEncode({'status': newStatus}),
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return {'status': false, 'message': data['message'] ?? 'Invalid status'};
      } else if (response.statusCode == 404) {
        return {'status': false, 'message': 'Booking not found'};
      } else if (response.statusCode == 401) {
        return {'status': false, 'message': 'Authentication required'};
      }
      
      return {'status': false, 'message': 'Failed to update booking status'};
    } catch (e) {
      debugPrint('Update booking status error: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }

  /// Delete booking
  Future<Map<String, dynamic>> deleteBooking(int bookingId) async {
    try {
      final response = await _authenticatedRequest(() => 
        http.delete(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminBookingDelete(bookingId)}'),
          headers: _headers,
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        return {'status': false, 'message': 'Booking not found'};
      } else if (response.statusCode == 401) {
        return {'status': false, 'message': 'Authentication required'};
      }
      
      return {'status': false, 'message': 'Failed to delete booking'};
    } catch (e) {
      debugPrint('Delete booking error: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }

  // ==================== PAYMENTS ====================

  /// Get list of payments with optional filtering and pagination
  Future<Map<String, dynamic>> getPayments({
    String status = 'all',
    String? search,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'status': status,
        'page': page.toString(),
        'per_page': perPage.toString(),
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminPayments}')
          .replace(queryParameters: queryParams);

      final response = await _authenticatedRequest(() => 
        http.get(uri, headers: _headers),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        return {'status': false, 'message': 'Authentication required'};
      }
      
      return {'status': false, 'message': 'Failed to fetch payments'};
    } catch (e) {
      debugPrint('Get payments error: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }

  /// Get payment detail by ID
  Future<Map<String, dynamic>> getPaymentDetail(int paymentId) async {
    try {
      final response = await _authenticatedRequest(() => 
        http.get(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminPaymentDetail(paymentId)}'),
          headers: _headers,
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        return {'status': false, 'message': 'Payment not found'};
      } else if (response.statusCode == 401) {
        return {'status': false, 'message': 'Authentication required'};
      }
      
      return {'status': false, 'message': 'Failed to fetch payment detail'};
    } catch (e) {
      debugPrint('Get payment detail error: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }

  /// Update payment status
  Future<Map<String, dynamic>> updatePaymentStatus(int paymentId, String newStatus) async {
    try {
      final response = await _authenticatedRequest(() => 
        http.post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminPaymentUpdateStatus(paymentId)}'),
          headers: _headers,
          body: jsonEncode({'status': newStatus}),
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return {'status': false, 'message': data['message'] ?? 'Invalid status'};
      } else if (response.statusCode == 404) {
        return {'status': false, 'message': 'Payment not found'};
      } else if (response.statusCode == 401) {
        return {'status': false, 'message': 'Authentication required'};
      }
      
      return {'status': false, 'message': 'Failed to update payment status'};
    } catch (e) {
      debugPrint('Update payment status error: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }

  // ==================== USERS ====================

  /// Get list of users with optional filtering and pagination
  Future<Map<String, dynamic>> getUsers({
    String status = 'all',
    String? search,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'status': status,
        'page': page.toString(),
        'per_page': perPage.toString(),
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminUsers}')
          .replace(queryParameters: queryParams);

      final response = await _authenticatedRequest(() => 
        http.get(uri, headers: _headers),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        return {'status': false, 'message': 'Authentication required'};
      }
      
      return {'status': false, 'message': 'Failed to fetch users'};
    } catch (e) {
      debugPrint('Get users error: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }

  // ==================== COACHES ====================

  /// Get list of coaches with optional filtering and pagination
  Future<Map<String, dynamic>> getCoaches({
    String status = 'all',
    String? search,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'status': status,
        'page': page.toString(),
        'per_page': perPage.toString(),
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminCoaches}')
          .replace(queryParameters: queryParams);

      final response = await _authenticatedRequest(() => 
        http.get(uri, headers: _headers),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        return {'status': false, 'message': 'Authentication required'};
      }
      
      return {'status': false, 'message': 'Failed to fetch coaches'};
    } catch (e) {
      debugPrint('Get coaches error: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan koneksi: ${e.toString()}',
      };
    }
  }
}
