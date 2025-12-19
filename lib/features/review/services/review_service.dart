import 'dart:convert';

import 'package:mamicoach_mobile/core/constants/api_constants.dart';
import 'package:mamicoach_mobile/features/review/models/reviews.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ReviewService {
  /// Public list of reviews for a course
  /// GET /api/courses/<course_id>/reviews/?page=&page_size=
  static Future<Map<String, dynamic>> listCourseReviews({
    required CookieRequest request,
    required int courseId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/courses/$courseId/reviews/').replace(
        queryParameters: {
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
      );

      final response = await request.get(uri.toString());

      if (response['success'] == true) {
        final rawReviews = (response['reviews'] as List?) ?? const [];
        return {
          'success': true,
          'reviews_raw': rawReviews.whereType<Map<String, dynamic>>().toList(),
          'pagination': response['pagination'],
        };
      }

      return {
        'success': false,
        'error': response['error'] ?? 'Failed to fetch course reviews',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Public list of reviews for a coach
  /// GET /api/coach/<coach_id>/reviews/?page=&page_size=
  static Future<Map<String, dynamic>> listCoachReviews({
    required CookieRequest request,
    required int coachId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/coach/$coachId/reviews/').replace(
        queryParameters: {
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
      );

      final response = await request.get(uri.toString());

      if (response['success'] == true) {
        final rawReviews = (response['reviews'] as List?) ?? const [];
        return {
          'success': true,
          'reviews_raw': rawReviews.whereType<Map<String, dynamic>>().toList(),
          'pagination': response['pagination'],
        };
      }

      return {
        'success': false,
        'error': response['error'] ?? 'Failed to fetch coach reviews',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  /// List current user's reviews
  /// GET /review/ajax/list-my/?course_id=&booking_id=
  static Future<Map<String, dynamic>> listMyReviews({
    required CookieRequest request,
    int? courseId,
    int? bookingId,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/review/ajax/list-my/').replace(
        queryParameters: {
          if (courseId != null) 'course_id': courseId.toString(),
          if (bookingId != null) 'booking_id': bookingId.toString(),
        },
      );

      final response = await request.get(uri.toString());

      if (response['success'] == true) {
        final rawReviews = (response['reviews'] as List?) ?? const [];
        return {
          'success': true,
          'reviews': rawReviews
              .whereType<Map<String, dynamic>>()
              .map((r) => Review.fromJson(r))
              .toList(),
        };
      }

      return {
        'success': false,
        'error': response['error'] ?? 'Failed to fetch reviews',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Create a new review for a booking
  /// POST /review/ajax/create/<booking_id>
  static Future<Map<String, dynamic>> createReview({
    required int bookingId,
    required int rating,
    required String content,
    required bool isAnonymous,
    required CookieRequest request,
  }) async {
    try {
      final url = '${ApiConstants.baseUrl}/review/ajax/create/$bookingId';

      final response = await request.postJson(
        url,
        jsonEncode({
          'rating': rating,
          'content': content,
          'is_anonymous': isAnonymous,
        }),
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'message': response['message'] ?? 'Review created successfully',
          'review_id': response['review_id'],
          'booking_id': response['booking_id'],
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ??
              response['errors']?.toString() ??
              'Failed to create review',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Edit an existing review
  /// POST /review/ajax/edit/<review_id>
  static Future<Map<String, dynamic>> editReview({
    required int reviewId,
    required int rating,
    required String content,
    required bool isAnonymous,
    required CookieRequest request,
  }) async {
    try {
      final url = '${ApiConstants.baseUrl}/review/ajax/edit/$reviewId';

      final response = await request.postJson(
        url,
        jsonEncode({
          'rating': rating,
          'content': content,
          'is_anonymous': isAnonymous,
        }),
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'message': response['message'] ?? 'Review updated successfully',
          'review_id': response['review_id'],
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ??
              response['errors']?.toString() ??
              'Failed to update review',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Delete a review
  /// POST /review/ajax/delete/<review_id>
  static Future<Map<String, dynamic>> deleteReview({
    required int reviewId,
    required CookieRequest request,
  }) async {
    try {
      final url = '${ApiConstants.baseUrl}/review/ajax/delete/$reviewId';

      final response = await request.post(url, {});

      if (response['success'] == true) {
        return {
          'success': true,
          'message': response['message'] ?? 'Review deleted successfully',
          'review_id': response['review_id'],
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to delete review',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Get a specific review
  /// GET /review/ajax/get/<review_id>
  static Future<Map<String, dynamic>> getReview({
    required int reviewId,
    required CookieRequest request,
  }) async {
    try {
      final url = '${ApiConstants.baseUrl}/review/ajax/get/$reviewId';

      final response = await request.get(url);

      if (response['success'] == true) {
        return {
          'success': true,
          'review': Review.fromJson(response['review']),
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to fetch review',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }
}
