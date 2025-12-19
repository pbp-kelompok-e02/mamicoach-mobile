/// Coach Model for MamiCoach Admin Panel
class Coach {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String specialization;
  final double rating;
  final String status;
  final DateTime joinDate;
  final String? avatar;
  final bool isVerified;

  Coach({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.specialization,
    required this.rating,
    required this.status,
    required this.joinDate,
    this.avatar,
    required this.isVerified,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      specialization: json['specialization'] ?? 'Umum',
      rating: (json['rating'] ?? 0).toDouble(),
      status: json['is_active'] == true ? 'Aktif' : 'Tidak Aktif',
      joinDate: DateTime.tryParse(json['date_joined'] ?? '') ?? DateTime.now(),
      avatar: json['profile_picture'],
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'specialization': specialization,
    'rating': rating,
    'is_active': status == 'Aktif',
    'date_joined': joinDate.toIso8601String(),
    'profile_picture': avatar,
    'is_verified': isVerified,
  };
}

class CoachPagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;

  CoachPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
  });

  factory CoachPagination.fromJson(Map<String, dynamic> json) {
    return CoachPagination(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalItems: json['total_items'] ?? 0,
      perPage: json['per_page'] ?? 10,
    );
  }
}
