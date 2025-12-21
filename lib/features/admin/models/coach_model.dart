/// Coach Model for MamiCoach Admin Panel
class Coach {
  final int id;
  final CoachUser user;
  final bool verified;
  final String? bio;
  final List<String> expertise;
  final double rating;
  final int ratingCount;
  final int totalMinutesCoached;
  final int balance;
  final String? profilePicture;
  final String verificationStatus;
  final DateTime createdAt;

  Coach({
    required this.id,
    required this.user,
    required this.verified,
    this.bio,
    required this.expertise,
    required this.rating,
    required this.ratingCount,
    required this.totalMinutesCoached,
    required this.balance,
    this.profilePicture,
    required this.verificationStatus,
    required this.createdAt,
  });

  /// Get display name from user object
  String get name {
    if (user.firstName != null && user.lastName != null) {
      return '${user.firstName} ${user.lastName}';
    } else if (user.firstName != null) {
      return user.firstName!;
    }
    return user.username;
  }

  /// Get email from user object
  String get email => user.email;

  /// Backward compatibility - avatar field
  String? get avatar => profilePicture;

  /// Get specialization from expertise list
  String get specialization => expertise.isNotEmpty ? expertise.join(', ') : 'Umum';

  /// Backward compatibility - isVerified field
  bool get isVerified => verified;

  /// Backward compatibility - status field
  String get status => statusDisplay;

  /// Get status display text
  String get statusDisplay => user.isActive ? 'Aktif' : 'Tidak Aktif';

  /// Get join date from user object
  DateTime get joinDate => user.dateJoined;

  factory Coach.fromJson(Map<String, dynamic> json) {
    // Parse expertise - can be array or comma-separated string
    List<String> expertiseList = [];
    if (json['expertise'] != null) {
      if (json['expertise'] is List) {
        expertiseList = (json['expertise'] as List).map((e) => e.toString()).toList();
      } else if (json['expertise'] is String) {
        expertiseList = [json['expertise']];
      }
    }

    return Coach(
      id: json['id'] ?? 0,
      user: CoachUser.fromJson(json['user'] ?? {}),
      verified: json['verified'] ?? false,
      bio: json['bio'],
      expertise: expertiseList,
      rating: (json['rating'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      totalMinutesCoached: json['total_minutes_coached'] ?? 0,
      balance: json['balance'] ?? 0,
      profilePicture: json['profile_picture'],
      verificationStatus: json['verification_status'] ?? 'pending',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user.toJson(),
    'verified': verified,
    'bio': bio,
    'expertise': expertise,
    'rating': rating,
    'rating_count': ratingCount,
    'total_minutes_coached': totalMinutesCoached,
    'balance': balance,
    'profile_picture': profilePicture,
    'verification_status': verificationStatus,
    'created_at': createdAt.toIso8601String(),
  };
}

/// Coach User nested model
class CoachUser {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final bool isActive;
  final DateTime dateJoined;

  CoachUser({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    required this.isActive,
    required this.dateJoined,
  });

  factory CoachUser.fromJson(Map<String, dynamic> json) {
    return CoachUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      isActive: json['is_active'] ?? true,
      dateJoined: DateTime.tryParse(json['date_joined'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'is_active': isActive,
    'date_joined': dateJoined.toIso8601String(),
  };
}

class CoachPagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;
  final bool? hasNext;
  final bool? hasPrevious;

  CoachPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
    this.hasNext,
    this.hasPrevious,
  });

  factory CoachPagination.fromJson(Map<String, dynamic> json) {
    return CoachPagination(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalItems: json['total_items'] ?? 0,
      perPage: json['per_page'] ?? 10,
      hasNext: json['has_next'],
      hasPrevious: json['has_previous'],
    );
  }
}
