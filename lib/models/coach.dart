import 'dart:convert';

List<Coach> coachFromJson(String str) =>
    List<Coach>.from(json.decode(str).map((x) => Coach.fromJson(x)));

String coachToJson(List<Coach> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Coach {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String fullName;
  final String? bio;
  final List<String> expertise;
  final String? profileImageUrl;
  final double rating;
  final int ratingCount;
  final int totalMinutesCoached;
  final double totalHoursCoached;
  final String totalHoursCoachedFormatted;
  final int balance;
  final bool verified;
  final DateTime createdAt;
  final DateTime updatedAt;

  Coach({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.bio,
    required this.expertise,
    this.profileImageUrl,
    required this.rating,
    required this.ratingCount,
    required this.totalMinutesCoached,
    required this.totalHoursCoached,
    required this.totalHoursCoachedFormatted,
    required this.balance,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Coach.fromJson(Map<String, dynamic> json) => Coach(
    id: json["id"] ?? 0,
    username: json["username"] ?? '',
    firstName: json["first_name"] ?? '',
    lastName: json["last_name"] ?? '',
    fullName: json["full_name"] ?? '',
    bio: json["bio"],
    expertise: json["expertise"] != null
        ? List<String>.from(json["expertise"].map((x) => x))
        : [],
    profileImageUrl: json["profile_image_url"],
    rating: json["rating"]?.toDouble() ?? 0.0,
    ratingCount: json["rating_count"] ?? 0,
    totalMinutesCoached: json["total_minutes_coached"] ?? 0,
    totalHoursCoached: json["total_hours_coached"]?.toDouble() ?? 0.0,
    totalHoursCoachedFormatted:
        json["total_hours_coached_formatted"] ?? "0 jam",
    balance: json["balance"] ?? 0,
    verified: json["verified"] ?? false,
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : DateTime.now(),
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "full_name": fullName,
    "bio": bio,
    "expertise": List<dynamic>.from(expertise.map((x) => x)),
    "profile_image_url": profileImageUrl,
    "rating": rating,
    "rating_count": ratingCount,
    "total_minutes_coached": totalMinutesCoached,
    "total_hours_coached": totalHoursCoached,
    "total_hours_coached_formatted": totalHoursCoachedFormatted,
    "balance": balance,
    "verified": verified,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
