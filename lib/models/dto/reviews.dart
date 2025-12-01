import '../reviews.dart';

class ReviewCreateRequest {
  final int rating;
  final String content;
  final bool isAnonymous;

  ReviewCreateRequest({
    required this.rating,
    required this.content,
    required this.isAnonymous,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'content': content,
      'is_anonymous': isAnonymous,
    };
  }
}

class ReviewUpdateRequest {
  final int rating;
  final String content;
  final bool isAnonymous;

  ReviewUpdateRequest({
    required this.rating,
    required this.content,
    required this.isAnonymous,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'content': content,
      'is_anonymous': isAnonymous,
    };
  }
}

class ReviewCreateResponse {
  final bool success;
  final String? message;
  final int? reviewId;
  final int? bookingId;
  final Map<String, dynamic>? errors;
  final String? error;

  ReviewCreateResponse({
    required this.success,
    this.message,
    this.reviewId,
    this.bookingId,
    this.errors,
    this.error,
  });

  factory ReviewCreateResponse.fromJson(Map<String, dynamic> json) {
    return ReviewCreateResponse(
      success: json['success'] ?? false,
      message: json['message'],
      reviewId: json['review_id'],
      bookingId: json['booking_id'],
      errors: json['errors'],
      error: json['error'],
    );
  }
}

class ReviewUpdateResponse {
  final bool success;
  final String? message;
  final int? reviewId;
  final Map<String, dynamic>? errors;
  final String? error;

  ReviewUpdateResponse({
    required this.success,
    this.message,
    this.reviewId,
    this.errors,
    this.error,
  });

  factory ReviewUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ReviewUpdateResponse(
      success: json['success'] ?? false,
      message: json['message'],
      reviewId: json['review_id'],
      errors: json['errors'],
      error: json['error'],
    );
  }
}

class ReviewDeleteResponse {
  final bool success;
  final String? message;
  final int? reviewId;
  final String? error;

  ReviewDeleteResponse({
    required this.success,
    this.message,
    this.reviewId,
    this.error,
  });

  factory ReviewDeleteResponse.fromJson(Map<String, dynamic> json) {
    return ReviewDeleteResponse(
      success: json['success'] ?? false,
      message: json['message'],
      reviewId: json['review_id'],
      error: json['error'],
    );
  }
}

class ReviewGetResponse {
  final bool success;
  final Review? review;
  final String? error;

  ReviewGetResponse({
    required this.success,
    this.review,
    this.error,
  });

  factory ReviewGetResponse.fromJson(Map<String, dynamic> json) {
    return ReviewGetResponse(
      success: json['success'] ?? false,
      review: json['review'] != null ? Review.fromJson(json['review']) : null,
      error: json['error'],
    );
  }
}

class ReviewBookingCheckResponse {
  final bool success;
  final bool exists;
  final Review? review;
  final String? message;
  final String? error;

  ReviewBookingCheckResponse({
    required this.success,
    required this.exists,
    this.review,
    this.message,
    this.error,
  });

  factory ReviewBookingCheckResponse.fromJson(Map<String, dynamic> json) {
    return ReviewBookingCheckResponse(
      success: json['success'] ?? false,
      exists: json['exists'] ?? false,
      review: json['review'] != null ? Review.fromJson(json['review']) : null,
      message: json['message'],
      error: json['error'],
    );
  }
}
