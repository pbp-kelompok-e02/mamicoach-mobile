/// User Model for MamiCoach Admin Panel
class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final DateTime joinDate;
  final String status;
  final int totalBookings;
  final String? avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.joinDate,
    required this.status,
    required this.totalBookings,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      joinDate: DateTime.tryParse(json['date_joined'] ?? '') ?? DateTime.now(),
      status: json['is_active'] == true ? 'Aktif' : 'Tidak Aktif',
      totalBookings: json['total_bookings'] ?? 0,
      avatar: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'date_joined': joinDate.toIso8601String(),
    'is_active': status == 'Aktif',
    'total_bookings': totalBookings,
    'profile_picture': avatar,
  };
}

class UserPagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;

  UserPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
  });

  factory UserPagination.fromJson(Map<String, dynamic> json) {
    return UserPagination(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalItems: json['total_items'] ?? 0,
      perPage: json['per_page'] ?? 10,
    );
  }
}
