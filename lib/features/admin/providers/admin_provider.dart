import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin_user.dart';
import '../models/dashboard_stats.dart';
import '../../../core/constants/api_constants.dart';

/// Admin Authentication Provider for MamiCoach Admin Panel
class AdminAuthProvider extends ChangeNotifier {
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

  /// Initialize provider - check if admin was previously logged in
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('admin_user');
      
      if (userData != null) {
        _currentUser = AdminUser.fromJson(jsonDecode(userData));
        _isLoggedIn = true;
      }
    } catch (e) {
      debugPrint('Error initializing admin auth: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Login admin user
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminLogin}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && (data['status'] == true || data['success'] == true)) {
        // Create admin user from response
        _currentUser = AdminUser(
          id: data['user']?['id'] ?? 0,
          username: data['user']?['username'] ?? username,
          email: data['user']?['email'] ?? '',
          isSuperuser: data['user']?['is_superuser'] ?? false,
        );

        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('admin_user', jsonEncode(_currentUser!.toJson()));

        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = data['message'] ?? 'Login gagal. Periksa username dan password.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      // Demo mode - allow login with demo credentials
      if (username == 'admin' && password == 'admin123') {
        _currentUser = AdminUser(
          id: 1,
          username: 'admin',
          email: 'admin@mamicoach.com',
          isSuperuser: true,
        );
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('admin_user', jsonEncode(_currentUser!.toJson()));
        
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
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
      await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminLogout}'),
        headers: {'Content-Type': 'application/json'},
      );
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
  DashboardStats? _stats;
  bool _isLoading = false;
  String? _error;

  DashboardProvider();

  // Getters
  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch dashboard statistics
  Future<void> fetchDashboardStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.apiAdminDashboard}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true || data['success'] == true) {
          _stats = DashboardStats.fromJson(data['data'] ?? data);
        } else {
          _stats = _getMockDashboardStats();
        }
      } else {
        _stats = _getMockDashboardStats();
      }
    } catch (e) {
      debugPrint('Error fetching dashboard stats: $e');
      // Use mock data when API fails
      _stats = _getMockDashboardStats();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Get mock dashboard stats for demo
  DashboardStats _getMockDashboardStats() {
    return DashboardStats(
      totalUsers: 1247,
      totalCoaches: 48,
      totalCourses: 156,
      totalBookings: 3892,
      pendingBookings: 23,
      completedBookings: 3420,
      totalRevenue: 45680000,
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
    );
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    await fetchDashboardStats();
  }
}
