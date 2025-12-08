import 'dart:convert';
import 'package:mamicoach_mobile/core/constants/api_constants.dart';
import 'package:mamicoach_mobile/models/reviews.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ReviewService {
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
          'error': response['error'] ?? response['errors']?.toString() ?? 'Failed to create review',
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
          'error': response['error'] ?? response['errors']?.toString() ?? 'Failed to update review',
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
