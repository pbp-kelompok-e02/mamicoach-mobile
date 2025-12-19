import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(
      json.decode(str).map((x) => CategoryModel.fromJson(x)),
    );

String categoryModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  int id;
  String name;
  String? description;
  String? thumbnailUrl;
  int courseCount;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.thumbnailUrl,
    required this.courseCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    description: json["description"],
    thumbnailUrl: json["thumbnail_url"],
    courseCount: json["course_count"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "thumbnail_url": thumbnailUrl,
    "course_count": courseCount,
  };
}
