/// Base URL for API requests.
///
/// Prefer importing this library as `api_constants` and using
/// `api_constants.baseUrl`.
const String baseUrl = ApiConstants.baseUrl;

/// API Constants for MamiCoach Admin Panel
class ApiConstants {
  // Base URL - Change this to your production URL when deploying
  // static const String baseUrl = 'https://mamicoach.vercel.app';
  // static const String baseUrl = 'http://10.0.2.2:8000'; // For Android Emulator
  static const String baseUrl = 'https://kevin-cornellius-mamicoach.pbp.cs.ui.ac.id'; // For Web/iOS Simulator

  // Admin API Endpoints (JWT Authentication)
  static const String adminApiBase = '/admin/api';
  
  // Authentication Endpoints
  static const String adminLogin = '$adminApiBase/login/';
  static const String adminRefresh = '$adminApiBase/refresh/';
  static const String adminLogout = '$adminApiBase/logout/';
  
  // Dashboard
  static const String adminDashboard = '$adminApiBase/dashboard/';
  
  // Bookings
  static const String adminBookings = '$adminApiBase/bookings/';
  static String adminBookingDetail(int bookingId) => '$adminApiBase/bookings/$bookingId/';
  static String adminBookingUpdateStatus(int bookingId) => '$adminApiBase/bookings/$bookingId/update-status/';
  static String adminBookingDelete(int bookingId) => '$adminApiBase/bookings/$bookingId/delete/';
  
  // Payments
  static const String adminPayments = '$adminApiBase/payments/';
  static String adminPaymentDetail(int paymentId) => '$adminApiBase/payments/$paymentId/';
  static String adminPaymentUpdateStatus(int paymentId) => '$adminApiBase/payments/$paymentId/update-status/';

  // Users
  static const String adminUsers = '$adminApiBase/users/';
  static String adminUserDetail(int userId) => '$adminApiBase/users/$userId/';
  static String adminUserUpdateStatus(int userId) => '$adminApiBase/users/$userId/update-status/';

  // Coaches
  static const String adminCoaches = '$adminApiBase/coaches/';
  static String adminCoachDetail(int coachId) => '$adminApiBase/coaches/$coachId/';
  static String adminCoachVerify(int coachId) => '$adminApiBase/coaches/$coachId/verify/';

  // Token Settings
  static const int accessTokenExpirySeconds = 86400; // 24 hours
  static const int refreshTokenExpiryDays = 7;
}
