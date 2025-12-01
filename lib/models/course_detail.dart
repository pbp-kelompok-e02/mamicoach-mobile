import 'dart:convert';
import 'package:mamicoach_mobile/models/course.dart';

CourseDetail courseDetailFromJson(String str) =>
    CourseDetail.fromJson(json.decode(str));

String courseDetailToJson(CourseDetail data) => json.encode(data.toJson());

class CourseDetail {
  int id;
  String title;
  String description;
  String location;
  int price;
  String priceFormatted;
  int duration;
  String durationFormatted;
  double rating;
  int ratingCount;
  String? thumbnailUrl;
  DateTime createdAt;
  DateTime updatedAt;
  Category category;
  CoachDetailInfo coach;
  List<RelatedCourse> relatedCourses;

  CourseDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.priceFormatted,
    required this.duration,
    required this.durationFormatted,
    required this.rating,
    required this.ratingCount,
    this.thumbnailUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.coach,
    required this.relatedCourses,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) => CourseDetail(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    location: json["location"],
    price: json["price"],
    priceFormatted: json["price_formatted"],
    duration: json["duration"],
    durationFormatted: json["duration_formatted"],
    rating: json["rating"]?.toDouble() ?? 0.0,
    ratingCount: json["rating_count"] ?? 0,
    thumbnailUrl: json["thumbnail_url"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    category: Category.fromJson(json["category"]),
    coach: CoachDetailInfo.fromJson(json["coach"]),
    relatedCourses: List<RelatedCourse>.from(
      json["related_courses"].map((x) => RelatedCourse.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "location": location,
    "price": price,
    "price_formatted": priceFormatted,
    "duration": duration,
    "duration_formatted": durationFormatted,
    "rating": rating,
    "rating_count": ratingCount,
    "thumbnail_url": thumbnailUrl,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "category": category.toJson(),
    "coach": coach.toJson(),
    "related_courses": List<dynamic>.from(
      relatedCourses.map((x) => x.toJson()),
    ),
  };
}

class CoachDetailInfo {
  int id;
  String username;
  String firstName;
  String lastName;
  String fullName;
  String? bio;
  List<String> expertise;
  String? profileImageUrl;
  double rating;
  int ratingCount;
  String totalHoursCoachedFormatted;
  bool verified;

  CoachDetailInfo({
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
    required this.totalHoursCoachedFormatted,
    required this.verified,
  });

  factory CoachDetailInfo.fromJson(Map<String, dynamic> json) =>
      CoachDetailInfo(
        id: json["id"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        fullName: json["full_name"],
        bio: json["bio"],
        expertise: List<String>.from(json["expertise"].map((x) => x)),
        profileImageUrl: json["profile_image_url"],
        rating: json["rating"]?.toDouble() ?? 0.0,
        ratingCount: json["rating_count"] ?? 0,
        totalHoursCoachedFormatted:
            json["total_hours_coached_formatted"] ?? "0 jam",
        verified: json["verified"] ?? false,
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
    "total_hours_coached_formatted": totalHoursCoachedFormatted,
    "verified": verified,
  };
}

class RelatedCourse {
  int id;
  String title;
  int price;
  String priceFormatted;
  int duration;
  String durationFormatted;
  double rating;
  String? thumbnailUrl;

  RelatedCourse({
    required this.id,
    required this.title,
    required this.price,
    required this.priceFormatted,
    required this.duration,
    required this.durationFormatted,
    required this.rating,
    this.thumbnailUrl,
  });

  factory RelatedCourse.fromJson(Map<String, dynamic> json) => RelatedCourse(
    id: json["id"],
    title: json["title"],
    price: json["price"],
    priceFormatted: json["price_formatted"],
    duration: json["duration"],
    durationFormatted: json["duration_formatted"],
    rating: json["rating"]?.toDouble() ?? 0.0,
    thumbnailUrl: json["thumbnail_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "price_formatted": priceFormatted,
    "duration": duration,
    "duration_formatted": durationFormatted,
    "rating": rating,
    "thumbnail_url": thumbnailUrl,
  };
}
