import 'dart:convert';
import 'package:mamicoach_mobile/models/course.dart';

CoachDetail coachDetailFromJson(String str) =>
    CoachDetail.fromJson(json.decode(str));

String coachDetailToJson(CoachDetail data) => json.encode(data.toJson());

class CoachDetail {
  int id;
  String username;
  String firstName;
  String lastName;
  String fullName;
  String? email;
  String? bio;
  List<String> expertise;
  String? profileImageUrl;
  double rating;
  int ratingCount;
  int totalMinutesCoached;
  double totalHoursCoached;
  String totalHoursCoachedFormatted;
  int balance;
  bool verified;
  DateTime createdAt;
  DateTime updatedAt;
  List<CoachCourse> courses;
  int totalCourses;

  CoachDetail({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.email,
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
    required this.courses,
    required this.totalCourses,
  });

  factory CoachDetail.fromJson(Map<String, dynamic> json) => CoachDetail(
    id: json["id"],
    username: json["username"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    fullName: json["full_name"],
    email: json["email"],
    bio: json["bio"],
    expertise: List<String>.from(json["expertise"].map((x) => x)),
    profileImageUrl: json["profile_image_url"],
    rating: json["rating"]?.toDouble() ?? 0.0,
    ratingCount: json["rating_count"] ?? 0,
    totalMinutesCoached: json["total_minutes_coached"] ?? 0,
    totalHoursCoached: json["total_hours_coached"]?.toDouble() ?? 0.0,
    totalHoursCoachedFormatted:
        json["total_hours_coached_formatted"] ?? "0 jam",
    balance: json["balance"] ?? 0,
    verified: json["verified"] ?? false,
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    courses: List<CoachCourse>.from(
      json["courses"].map((x) => CoachCourse.fromJson(x)),
    ),
    totalCourses: json["total_courses"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "full_name": fullName,
    "email": email,
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
    "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
    "total_courses": totalCourses,
  };
}

class CoachCourse {
  int id;
  String title;
  Category category;
  int price;
  String priceFormatted;
  int duration;
  String durationFormatted;
  double rating;
  int ratingCount;
  String? thumbnailUrl;

  CoachCourse({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.priceFormatted,
    required this.duration,
    required this.durationFormatted,
    required this.rating,
    required this.ratingCount,
    this.thumbnailUrl,
  });

  factory CoachCourse.fromJson(Map<String, dynamic> json) => CoachCourse(
    id: json["id"],
    title: json["title"],
    category: Category.fromJson(json["category"]),
    price: json["price"],
    priceFormatted: json["price_formatted"],
    duration: json["duration"],
    durationFormatted: json["duration_formatted"],
    rating: json["rating"]?.toDouble() ?? 0.0,
    ratingCount: json["rating_count"] ?? 0,
    thumbnailUrl: json["thumbnail_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "category": category.toJson(),
    "price": price,
    "price_formatted": priceFormatted,
    "duration": duration,
    "duration_formatted": durationFormatted,
    "rating": rating,
    "rating_count": ratingCount,
    "thumbnail_url": thumbnailUrl,
  };
}
