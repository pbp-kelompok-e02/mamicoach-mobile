import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart' as api_constants;
import 'package:mamicoach_mobile/models/booking.dart';
import 'package:mamicoach_mobile/utils/datetime_utils.dart';
import 'package:intl/intl.dart';

class BookingService {
  /// Get available dates for a coach and course
  /// Maps to Django: /booking/api/coach/<coach_id>/available-dates/?course_id=<course_id>
  static Future<List<DateTime>> getAvailableDates(
    CookieRequest request,
    int coachId,
    int courseId,
  ) async {
    try {
      final response = await request.get(
        '${api_constants.baseUrl}/booking/api/coach/$coachId/available-dates/?course_id=$courseId',
      );
      
      // Django returns: { "available_dates": [{"date": "2025-12-20", ...}], ... }
      if (response['available_dates'] != null) {
        return (response['available_dates'] as List)
            .map((item) => DateTime.parse(item['date']))
            .toList();
      }
      
      // If no available_dates key, return empty list
      return [];
    } catch (e) {
      throw Exception('Error fetching available dates: $e');
    }
  }

  /// Get available times for a specific date
  /// Maps to Django: /booking/api/coach/<coach_id>/available-times/?course_id=<course_id>&date=<date>
  static Future<List<Map<String, dynamic>>> getAvailableTimes(
    CookieRequest request,
    int coachId,
    int courseId,
    DateTime date,
    int courseDurationMinutes,
  ) async {
    try {
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await request.get(
        '${api_constants.baseUrl}/booking/api/coach/$coachId/available-times/?course_id=$courseId&date=$dateStr',
      );
      
      // Django returns: { "available_times": [{"start_time": "10:00", ...}], ... }
      if (response['available_times'] != null) {
        final timeSlots = <Map<String, dynamic>>[];
        final now = DateTime.now();
        
        for (var item in response['available_times']) {
          final startTimeStr = item['start_time'] as String;
          
          // Combine date with time string in WIB timezone
          final startDatetime = DateTimeUtils.combineDateTime(date, startTimeStr);
          
          // Skip slots where less than 1 hour until class starts
          final hoursUntilClass = startDatetime.difference(now).inHours;
          if (hoursUntilClass < 1) {
            continue;
          }
          
          final endDatetime = startDatetime.add(Duration(minutes: courseDurationMinutes));
          
          timeSlots.add({
            'start_datetime': startDatetime.toIso8601String(),
            'end_datetime': endDatetime.toIso8601String(),
            'start_time': startTimeStr,
            'available': true,
          });
        }
        
        return timeSlots;
      }
      
      return [];
    } catch (e) {
      throw Exception('Error fetching available times: $e');
    }
  }

  /// Get course start times
  /// Maps to Django: /booking/api/course/<course_id>/start-times/?coach_id=<coach_id>
  static Future<List<Map<String, dynamic>>> getCourseStartTimes(
    CookieRequest request,
    int courseId,
    int coachId,
  ) async {
    try {
      final response = await request.get(
        '${api_constants.baseUrl}/booking/api/course/$courseId/start-times/?coach_id=$coachId',
      );
      
      if (response['success'] == true) {
        return List<Map<String, dynamic>>.from(response['start_times']);
      }
      throw Exception(response['message'] ?? 'Failed to fetch course start times');
    } catch (e) {
      throw Exception('Error fetching course start times: $e');
    }
  }

  /// Create a new booking
  /// Maps to Django: /booking/api/booking/create/
  static Future<Map<String, dynamic>> createBooking(
    CookieRequest request,
    int courseId,
    int coachId,
    DateTime startDatetime,
    DateTime endDatetime,
  ) async {
    try {
      // Send datetime directly without timezone conversion (all users in WIB)
      // Format date as YYYY-MM-DD and time as HH:mm for Django
      final dateStr = DateFormat('yyyy-MM-dd').format(startDatetime);
      final startTimeStr = DateFormat('HH:mm').format(startDatetime);
      
      final response = await request.post(
        '${api_constants.baseUrl}/booking/api/course/$courseId/create/',
        {
          'date': dateStr,
          'start_time': startTimeStr,
        },
      );
      
      return response;
    } catch (e) {
      throw Exception('Error creating booking: $e');
    }
  }

  /// Get user's bookings
  /// Maps to Django: /booking/api/bookings/
  static Future<List<Booking>> getUserBookings(CookieRequest request) async {
    try {
      final response = await request.get(
        '${api_constants.baseUrl}/booking/api/bookings/',
      );
      
      if (response['success'] == true) {
        return (response['bookings'] as List)
            .map((json) => Booking.fromJson(json))
            .toList();
      }
      throw Exception(response['message'] ?? 'Failed to fetch bookings');
    } catch (e) {
      throw Exception('Error fetching user bookings: $e');
    }
  }

  /// Get coach's bookings
  /// Maps to Django: /booking/api/bookings/?role=coach
  static Future<List<Booking>> getCoachBookings(CookieRequest request) async {
    try {
      final response = await request.get(
        '${api_constants.baseUrl}/booking/api/bookings/?role=coach',
      );
      
      if (response['success'] == true) {
        return (response['bookings'] as List)
            .map((json) => Booking.fromJson(json))
            .toList();
      }
      throw Exception(response['message'] ?? 'Failed to fetch coach bookings');
    } catch (e) {
      throw Exception('Error fetching coach bookings: $e');
    }
  }

  /// Cancel a booking
  /// Maps to Django: /booking/api/booking/<booking_id>/cancel/
  static Future<Map<String, dynamic>> cancelBooking(
    CookieRequest request,
    int bookingId,
  ) async {
    try {
      final response = await request.post(
        '${api_constants.baseUrl}/booking/api/booking/$bookingId/cancel/',
        {},
      );
      
      if (response['success'] == true) {
        return response;
      }
      throw Exception(response['message'] ?? 'Failed to cancel booking');
    } catch (e) {
      throw Exception('Error canceling booking: $e');
    }
  }

  /// Mark booking as paid (after payment success)
  /// Maps to Django: /booking/api/booking/<booking_id>/mark-paid/
  static Future<Map<String, dynamic>> markAsPaid(
    CookieRequest request,
    int bookingId,
  ) async {
    try {
      final response = await request.post(
        '${api_constants.baseUrl}/booking/api/booking/$bookingId/mark-paid/',
        {},
      );
      
      return response;
    } catch (e) {
      throw Exception('Error marking booking as paid: $e');
    }
  }

  /// Update booking status (coach only)
  /// Maps to Django: /booking/api/booking/<booking_id>/status/
  static Future<Map<String, dynamic>> updateBookingStatus(
    CookieRequest request,
    int bookingId,
    String status, // 'confirmed' or 'done'
  ) async {
    try {
      final response = await request.post(
        '${api_constants.baseUrl}/booking/api/booking/$bookingId/status/',
        {'status': status},
      );
      
      if (response['success'] == true) {
        return response;
      }
      throw Exception(response['message'] ?? 'Failed to update booking status');
    } catch (e) {
      throw Exception('Error updating booking status: $e');
    }
  }

  /// Confirm booking (coach only) - convenience method
  static Future<Map<String, dynamic>> confirmBooking(
    CookieRequest request,
    int bookingId,
  ) async {
    return updateBookingStatus(request, bookingId, 'confirmed');
  }

  /// Complete booking (coach only) - convenience method
  static Future<Map<String, dynamic>> completeBooking(
    CookieRequest request,
    int bookingId,
  ) async {
    return updateBookingStatus(request, bookingId, 'done');
  }

  /// Get booking detail
  /// Maps to Django: /booking/api/booking/<booking_id>/
  static Future<Booking> getBookingDetail(
    CookieRequest request,
    int bookingId,
  ) async {
    try {
      final response = await request.get(
        '${api_constants.baseUrl}/booking/api/booking/$bookingId/',
      );
      
      if (response['success'] == true) {
        return Booking.fromJson(response['booking']);
      }
      throw Exception(response['message'] ?? 'Failed to fetch booking detail');
    } catch (e) {
      throw Exception('Error fetching booking detail: $e');
    }
  }
}
