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
