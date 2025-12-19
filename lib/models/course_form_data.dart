/// Type-safe form data for creating/updating courses
/// Maps to Django Course model fields
class CourseFormData {
  final int categoryId;
  final String title;
  final String description;
  final String location;
  final int price; // In smallest currency unit (rupiah)
  final int duration; // In minutes
  final String? thumbnailUrl;

  CourseFormData({
    required this.categoryId,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.duration,
    this.thumbnailUrl,
  });

  /// Validate form data before submission
  bool validate() {
    if (title.trim().isEmpty) return false;
    if (description.trim().isEmpty) return false;
    if (location.trim().isEmpty) return false;
    if (price <= 0) return false;
    if (duration <= 0) return false;
    return true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'category_id': categoryId.toString(),
      'title': title.trim(),
      'description': description.trim(),
      'location': location.trim(),
      'price': price.toString(),
      'duration': duration.toString(),
    };

    if (thumbnailUrl != null && thumbnailUrl!.trim().isNotEmpty) {
      data['thumbnail_url'] = thumbnailUrl!.trim();
    }

    return data;
  }

  /// Create from existing Course for editing
  factory CourseFormData.fromCourse({
    required int id,
    required int categoryId,
    required String title,
    required String description,
    required String location,
    required int price,
    required int duration,
    String? thumbnailUrl,
  }) {
    return CourseFormData(
      categoryId: categoryId,
      title: title,
      description: description,
      location: location,
      price: price,
      duration: duration,
      thumbnailUrl: thumbnailUrl,
    );
  }

  @override
  String toString() {
    return 'CourseFormData(categoryId: $categoryId, title: $title, price: $price, duration: $duration)';
  }
}
