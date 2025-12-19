import 'dart:convert';

List<Course> courseFromJson(String str) =>
    List<Course>.from(json.decode(str).map((x) => Course.fromJson(x)));

String courseToJson(List<Course> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Course {
  final int id;
  final String title;
  final String description;
  final String location;
  final int price;
  final String priceFormatted;
  final int duration;
  final String durationFormatted;
  final double rating;
  final int ratingCount;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category category;
  final CoachInfo coach;

  Course({
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
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"] ?? 0,
    title: json["title"] ?? '',
    description: json["description"] ?? '',
    location: json["location"] ?? '',
    price: json["price"] ?? 0,
    priceFormatted: json["price_formatted"] ?? 'Rp 0',
    duration: json["duration"] ?? 0,
    durationFormatted: json["duration_formatted"] ?? '0 menit',
    rating: json["rating"]?.toDouble() ?? 0.0,
    ratingCount: json["rating_count"] ?? 0,
    thumbnailUrl: json["thumbnail_url"],
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : DateTime.now(),
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : DateTime.now(),
    category: Category.fromJson(json["category"] ?? {}),
    coach: CoachInfo.fromJson(json["coach"] ?? {}),
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
  };
}

class Category {
  final int id;
  final String name;
  final String? description;
  final String? thumbnailUrl;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.thumbnailUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    description: json["description"],
    thumbnailUrl: json["thumbnail_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "thumbnail_url": thumbnailUrl,
  };
}

class CoachInfo {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String fullName;
  final String? profileImageUrl;
  final double rating;
  final bool verified;

  CoachInfo({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.profileImageUrl,
    required this.rating,
    required this.verified,
  });

  factory CoachInfo.fromJson(Map<String, dynamic> json) => CoachInfo(
    id: json["id"] ?? 0,
    username: json["username"] ?? '',
    firstName: json["first_name"] ?? '',
    lastName: json["last_name"] ?? '',
    fullName: json["full_name"] ?? '',
    profileImageUrl: json["profile_image_url"],
    rating: json["rating"]?.toDouble() ?? 0.0,
    verified: json["verified"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "full_name": fullName,
    "profile_image_url": profileImageUrl,
    "rating": rating,
    "verified": verified,
  };
}
