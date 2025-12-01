/// Admin User Model for MamiCoach Admin Panel
class AdminUser {
  final int id;
  final String username;
  final String email;
  final bool isSuperuser;
  final DateTime? lastLogin;

  AdminUser({
    required this.id,
    required this.username,
    required this.email,
    this.isSuperuser = false,
    this.lastLogin,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isSuperuser: json['is_superuser'] ?? false,
      lastLogin: json['last_login'] != null
          ? DateTime.tryParse(json['last_login'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'is_superuser': isSuperuser,
      'last_login': lastLogin?.toIso8601String(),
    };
  }
}
