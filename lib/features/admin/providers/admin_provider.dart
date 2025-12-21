import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin_user.dart';
import '../models/dashboard_stats.dart';
import '../services/admin_api_service.dart';

/// Admin Authentication Provider for MamiCoach Admin Panel
/// Uses JWT Bearer token authentication
class AdminAuthProvider extends ChangeNotifier {
  final AdminApiService _apiService = AdminApiService();
  
  AdminUser? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  AdminAuthProvider();

  // Getters
  AdminUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;
  bool get isAuthenticated => _apiService.isAuthenticated;

  /// Initialize provider - check if admin was previously logged in
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load tokens from storage
      await _apiService.loadTokens();
      
      // Load user data from storage
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('admin_user');
      
      if (userData != null && _apiService.isAuthenticated) {
        _currentUser = AdminUser.fromJson(jsonDecode(userData));
        _isLoggedIn = true;
      } else if (_apiService.refreshToken != null) {
        // Try to refresh token if we have a refresh token
        final refreshed = await _apiService.refreshAccessToken();
        if (refreshed && userData != null) {
          _currentUser = AdminUser.fromJson(jsonDecode(userData));
          _isLoggedIn = true;
        }
      }
    } catch (e) {
      debugPrint('Error initializing admin auth: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Login admin user with JWT authentication
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(username, password);

      if (response['status'] == true) {
        final userData = response['data']['user'];
        
        // Create admin user from response
        _currentUser = AdminUser(
          id: userData['id'] ?? 0,
          username: userData['username'] ?? username,
          email: userData['email'] ?? '',
          isSuperuser: userData['is_superuser'] ?? true,
        );

        // Save user data to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('admin_user', jsonEncode(_currentUser!.toJson()));

        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Login gagal. Periksa username dan password.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout admin user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.logout();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }

    // Clear local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_user');

    _currentUser = null;
    _isLoggedIn = false;
    _isLoading = false;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

/// Dashboard Provider for MamiCoach Admin Panel
class DashboardProvider extends ChangeNotifier {
  final AdminApiService _apiService = AdminApiService();
  
  DashboardStats? _stats;
  bool _isLoading = false;
  String? _error;

  DashboardProvider();

  // Getters
  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch dashboard statistics from API
  Future<void> fetchDashboardStats() async {
    debugPrint('[ADMIN PROVIDER] 🔄 Starting dashboard stats fetch...');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getDashboardStats();

      if (response['status'] == true) {
        _stats = DashboardStats.fromApiResponse(response['data']);
        debugPrint('[ADMIN PROVIDER] ✅ Dashboard stats loaded from API');
      } else {
        _error = response['message'];
        debugPrint('[ADMIN PROVIDER] ⚠️ API returned error: $_error');
        debugPrint('[ADMIN PROVIDER] 📊 Using mock dashboard data');
        // Use mock data when API fails
        _stats = _getMockDashboardStats();
      }
    } catch (e) {
      debugPrint('[ADMIN PROVIDER] ❌ Error fetching dashboard stats: $e');
      _error = e.toString();
      debugPrint('[ADMIN PROVIDER] 📊 Using mock dashboard data');
      // Use mock data when API fails
      _stats = _getMockDashboardStats();
    }

    _isLoading = false;
    notifyListeners();
    debugPrint('[ADMIN PROVIDER] ✔️ Dashboard stats fetch completed');
  }

  /// Get mock dashboard stats for demo
  DashboardStats _getMockDashboardStats() {
    return DashboardStats(
      totalUsers: 150,
      totalCoaches: 25,
      totalCourses: 40,
      totalBookings: 320,
      pendingBookings: 15,
      completedBookings: 230,
      totalRevenue: 45000000,
      newUsersThisMonth: 89,
      bookingsTrend: [
        ChartData(label: 'Sen', value: 45),
        ChartData(label: 'Sel', value: 52),
        ChartData(label: 'Rab', value: 38),
        ChartData(label: 'Kam', value: 65),
        ChartData(label: 'Jum', value: 78),
        ChartData(label: 'Sab', value: 92),
        ChartData(label: 'Min', value: 68),
      ],
      revenueTrend: [
        ChartData(label: 'Jan', value: 3200000),
        ChartData(label: 'Feb', value: 3800000),
        ChartData(label: 'Mar', value: 4200000),
        ChartData(label: 'Apr', value: 3900000),
        ChartData(label: 'Mei', value: 4500000),
        ChartData(label: 'Jun', value: 5200000),
      ],
      topCategories: [
        CategoryStats(name: 'Yoga', count: 45, percentage: 28),
        CategoryStats(name: 'Fitness', count: 38, percentage: 24),
        CategoryStats(name: 'Meditasi', count: 32, percentage: 20),
        CategoryStats(name: 'Nutrisi', count: 25, percentage: 16),
        CategoryStats(name: 'Lainnya', count: 16, percentage: 12),
      ],
      recentBookings: [],
      recentPayments: [],
    );
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    await fetchDashboardStats();
  }
}
