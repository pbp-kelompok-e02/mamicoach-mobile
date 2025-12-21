/// Dashboard Statistics Model for MamiCoach Admin Panel
class DashboardStats {
  final int totalUsers;
  final int totalCoaches;
  final int totalCourses;
  final int totalBookings;
  final int pendingBookings;
  final int completedBookings;
  final double totalRevenue;
  final int newUsersThisMonth;
  final List<ChartData> bookingsTrend;
  final List<ChartData> revenueTrend;
  final List<CategoryStats> topCategories;
  final List<Map<String, dynamic>> recentBookings;
  final List<Map<String, dynamic>> recentPayments;

  DashboardStats({
    required this.totalUsers,
    required this.totalCoaches,
    required this.totalCourses,
    required this.totalBookings,
    required this.pendingBookings,
    required this.completedBookings,
    required this.totalRevenue,
    required this.newUsersThisMonth,
    required this.bookingsTrend,
    required this.revenueTrend,
    required this.topCategories,
    required this.recentBookings,
    required this.recentPayments,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsers: json['total_users'] ?? 0,
      totalCoaches: json['total_coaches'] ?? 0,
      totalCourses: json['total_courses'] ?? 0,
      totalBookings: json['total_bookings'] ?? 0,
      pendingBookings: json['pending_bookings'] ?? 0,
      completedBookings: json['completed_bookings'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      newUsersThisMonth: json['new_users_this_month'] ?? 0,
      bookingsTrend: (json['bookings_trend'] as List<dynamic>?)
              ?.map((e) => ChartData.fromJson(e))
              .toList() ??
          [],
      revenueTrend: (json['revenue_trend'] as List<dynamic>?)
              ?.map((e) => ChartData.fromJson(e))
              .toList() ??
          [],
      topCategories: (json['top_categories'] as List<dynamic>?)
              ?.map((e) => CategoryStats.fromJson(e))
              .toList() ??
          [],
      recentBookings: (json['recent_bookings'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      recentPayments: (json['recent_payments'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }

  factory DashboardStats.empty() {
    return DashboardStats(
      totalUsers: 0,
      totalCoaches: 0,
      totalCourses: 0,
      totalBookings: 0,
      pendingBookings: 0,
      completedBookings: 0,
      totalRevenue: 0,
      newUsersThisMonth: 0,
      bookingsTrend: [],
      revenueTrend: [],
      topCategories: [],
      recentBookings: [],
      recentPayments: [],
    );
  }

  /// Create DashboardStats from API response format
  /// API returns: { overview, bookings, payments, recent_bookings, recent_payments }
  factory DashboardStats.fromApiResponse(Map<String, dynamic> data) {
    final overview = data['overview'] as Map<String, dynamic>? ?? {};
    final bookings = data['bookings'] as Map<String, dynamic>? ?? {};
    final payments = data['payments'] as Map<String, dynamic>? ?? {};
    
    return DashboardStats(
      totalUsers: overview['total_users'] ?? 0,
      totalCoaches: overview['total_coaches'] ?? 0,
      totalCourses: overview['total_courses'] ?? 0,
      totalBookings: bookings['total'] ?? overview['total_bookings'] ?? 0,
      pendingBookings: bookings['pending'] ?? overview['pending_bookings'] ?? 0,
      completedBookings: bookings['completed'] ?? overview['completed_bookings'] ?? 0,
      totalRevenue: (payments['total_revenue'] ?? overview['total_revenue'] ?? 0).toDouble(),
      newUsersThisMonth: overview['new_users_this_month'] ?? 0,
      bookingsTrend: (data['bookings_trend'] as List<dynamic>?)
              ?.map((e) => ChartData.fromJson(e))
              .toList() ??
          [],
      revenueTrend: (data['revenue_trend'] as List<dynamic>?)
              ?.map((e) => ChartData.fromJson(e))
              .toList() ??
          [],
      topCategories: (data['top_categories'] as List<dynamic>?)
              ?.map((e) => CategoryStats.fromJson(e))
              .toList() ??
          [],
      recentBookings: (data['recent_bookings'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      recentPayments: (data['recent_payments'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }
}

class ChartData {
  final String label;
  final double value;

  ChartData({required this.label, required this.value});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
    );
  }
}

class CategoryStats {
  final String name;
  final int count;
  final double percentage;

  CategoryStats({
    required this.name,
    required this.count,
    required this.percentage,
  });

  factory CategoryStats.fromJson(Map<String, dynamic> json) {
    return CategoryStats(
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }
}
