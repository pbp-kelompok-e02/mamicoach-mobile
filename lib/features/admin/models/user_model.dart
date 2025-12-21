/// User Model for MamiCoach Admin Panel
class User {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final bool isActive;
  final DateTime dateJoined;
  final DateTime? lastLogin;
  final UserProfile? profile;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    required this.isActive,
    required this.dateJoined,
    this.lastLogin,
    this.profile,
  });

  /// Get display name (first + last name or username)
  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    }
    return username;
  }

  /// Backward compatibility - use displayName for name
  String get name => displayName;

  /// Backward compatibility - get avatar from profile
  String? get avatar => profile?.profilePicture;

  /// Backward compatibility - get phone from profile
  String? get phone => profile?.phone;

  /// Backward compatibility - status field
  String get status => statusDisplay;

  /// Backward compatibility - joinDate field
  DateTime get joinDate => dateJoined;

  /// Backward compatibility - totalBookings (not available from API, return 0)
  int get totalBookings => 0;

  /// Get status display text
  String get statusDisplay => isActive ? 'Aktif' : 'Tidak Aktif';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      isActive: json['is_active'] ?? true,
      dateJoined: DateTime.tryParse(json['date_joined'] ?? '') ?? DateTime.now(),
      lastLogin: json['last_login'] != null ? DateTime.tryParse(json['last_login']) : null,
      profile: json['profile'] != null ? UserProfile.fromJson(json['profile']) : null,
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
    'last_login': lastLogin?.toIso8601String(),
    'profile': profile?.toJson(),
  };
}

/// User Profile nested model
class UserProfile {
  final int id;
  final String? phone;
  final String? bio;
  final String? profilePicture;

  UserProfile({
    required this.id,
    this.phone,
    this.bio,
    this.profilePicture,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      phone: json['phone'],
      bio: json['bio'],
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'phone': phone,
    'bio': bio,
    'profile_picture': profilePicture,
  };
}

class UserPagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;
  final bool? hasNext;
  final bool? hasPrevious;

  UserPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
    this.hasNext,
    this.hasPrevious,
  });

  factory UserPagination.fromJson(Map<String, dynamic> json) {
    return UserPagination(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalItems: json['total_items'] ?? 0,
      perPage: json['per_page'] ?? 10,
      hasNext: json['has_next'],
      hasPrevious: json['has_previous'],
    );
  }
}
