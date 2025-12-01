class Review {
  final int id;
  final int rating;
  final String content;
  final bool isAnonymous;
  final int bookingId;
  final int courseId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.rating,
    required this.content,
    required this.isAnonymous,
    required this.bookingId,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      rating: json['rating'],
      content: json['content'],
      isAnonymous: json['is_anonymous'] ?? false,
      bookingId: json['booking_id'],
      courseId: json['course_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'content': content,
      'is_anonymous': isAnonymous,
      'booking_id': bookingId,
      'course_id': courseId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
