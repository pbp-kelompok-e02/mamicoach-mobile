/// Booking Model for MamiCoach Admin Panel
class Booking {
  final int id;
  final BookingUser user;
  final BookingCoach? coach;
  final BookingCourse course;
  final DateTime startDatetime;
  final DateTime endDatetime;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.user,
    this.coach,
    required this.course,
    required this.startDatetime,
    required this.endDatetime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? 0,
      user: BookingUser.fromJson(json['user'] ?? {}),
      coach: json['coach'] != null ? BookingCoach.fromJson(json['coach']) : null,
      course: BookingCourse.fromJson(json['course'] ?? {}),
      startDatetime: DateTime.tryParse(json['start_datetime'] ?? '') ?? DateTime.now(),
      endDatetime: DateTime.tryParse(json['end_datetime'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user.toJson(),
    'coach': coach?.toJson(),
    'course': course.toJson(),
    'start_datetime': startDatetime.toIso8601String(),
    'end_datetime': endDatetime.toIso8601String(),
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  /// Get display name for status
  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'paid':
        return 'Sudah Dibayar';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'done':
        return 'Selesai';
      case 'canceled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  /// Check if booking can be canceled
  bool get canBeCanceled => status == 'pending' || status == 'paid';

  /// Check if booking is active
  bool get isActive => status == 'confirmed' || status == 'paid';

  /// Create a copy with updated fields
  Booking copyWith({
    int? id,
    BookingUser? user,
    BookingCoach? coach,
    BookingCourse? course,
    DateTime? startDatetime,
    DateTime? endDatetime,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      user: user ?? this.user,
      coach: coach ?? this.coach,
      course: course ?? this.course,
      startDatetime: startDatetime ?? this.startDatetime,
      endDatetime: endDatetime ?? this.endDatetime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BookingUser {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;

  BookingUser({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) {
    return BookingUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
  };

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    }
    return username;
  }
}

class BookingCoach {
  final int id;
  final String name;
  final String? email;

  BookingCoach({
    required this.id,
    required this.name,
    this.email,
  });

  factory BookingCoach.fromJson(Map<String, dynamic> json) {
    return BookingCoach(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}

class BookingCourse {
  final int id;
  final String title;
  final String? description;
  final double price;

  BookingCourse({
    required this.id,
    required this.title,
    this.description,
    required this.price,
  });

  factory BookingCourse.fromJson(Map<String, dynamic> json) {
    return BookingCourse(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
  };
}

/// Pagination info for booking list
class BookingPagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;
  final bool hasNext;
  final bool hasPrevious;

  BookingPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory BookingPagination.fromJson(Map<String, dynamic> json) {
    return BookingPagination(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalItems: json['total_items'] ?? 0,
      perPage: json['per_page'] ?? 10,
      hasNext: json['has_next'] ?? false,
      hasPrevious: json['has_previous'] ?? false,
    );
  }
}

/// Valid booking statuses
class BookingStatus {
  static const String pending = 'pending';
  static const String paid = 'paid';
  static const String confirmed = 'confirmed';
  static const String done = 'done';
  static const String canceled = 'canceled';

  static const List<String> all = [pending, paid, confirmed, done, canceled];

  static String getDisplayName(String status) {
    switch (status) {
      case pending:
        return 'Menunggu Pembayaran';
      case paid:
        return 'Sudah Dibayar';
      case confirmed:
        return 'Dikonfirmasi';
      case done:
        return 'Selesai';
      case canceled:
        return 'Dibatalkan';
      default:
        return status;
    }
  }
}
