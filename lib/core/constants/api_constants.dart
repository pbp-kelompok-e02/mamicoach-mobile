/// API Constants for MamiCoach Admin Panel
class ApiConstants {
  // Base URL - Change this to your production URL when deploying
  // static const String baseUrl = 'https://mamicoach.vercel.app';
  // static const String baseUrl = 'http://10.0.2.2:8000'; // For Android Emulator
  static const String baseUrl = 'http://localhost:8000'; // For Web/iOS Simulator

  // Admin Panel Endpoints
  static const String adminLogin = '/admin-panel/login/';
  static const String adminLogout = '/admin-panel/logout/';
  static const String adminDashboard = '/admin-panel/dashboard/';
  static const String adminUsers = '/admin-panel/users/';
  static const String adminCoaches = '/admin-panel/coaches/';
  static const String adminCourses = '/admin-panel/courses/';
  static const String adminBookings = '/admin-panel/bookings/';
  static const String adminPayments = '/admin-panel/payments/';
  static const String adminSettings = '/admin-panel/settings/';
  static const String adminLogs = '/admin-panel/logs/';

  // API Endpoints for mobile
  static const String apiAdminLogin = '/api/admin/login/';
  static const String apiAdminDashboard = '/api/admin/dashboard/';
  static const String apiAdminUsers = '/api/admin/users/';
  static const String apiAdminCoaches = '/api/admin/coaches/';
  static const String apiAdminCourses = '/api/admin/courses/';
  static const String apiAdminBookings = '/api/admin/bookings/';
  static const String apiAdminPayments = '/api/admin/payments/';
}
