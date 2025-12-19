import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart' as api_constants;
import 'package:mamicoach_mobile/models/coach_availability.dart';

class ScheduleService {
  /// Get list of coach availabilities
  /// Maps to Django: GET /schedule/api/availability/
  static Future<List<CoachAvailability>> getAvailabilities(
    CookieRequest request, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      String url = '${api_constants.baseUrl}/schedule/api/availability/';
      
      final params = <String>[];
      if (startDate != null) {
        final dateStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
        params.add('start_date=$dateStr');
      }
      if (endDate != null) {
        final dateStr = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
        params.add('end_date=$dateStr');
      }
      
      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }
      
      final response = await request.get(url);
      
      if (response['availabilities'] != null) {
        return (response['availabilities'] as List)
            .map((json) => CoachAvailability.fromJson(json))
            .toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Error fetching availabilities: $e');
    }
  }

  /// Create or update availability (upsert)
  /// Maps to Django: POST /schedule/api/availability/upsert/
  static Future<Map<String, dynamic>> upsertAvailability(
    CookieRequest request, {
    required DateTime date,
    required String startTime,
    required String endTime,
    String status = 'active',
  }) async {
    try {
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // Always use 'merge' mode to merge with existing schedules
      // This handles both: new additions and edits (after delete)
      final mode = 'merge';
      
      // Send as JSON string to avoid type issues
      final jsonData = jsonEncode({
        'date': dateStr,
        'ranges': [
          {
            'start': startTime,
            'end': endTime,
            'status': status,  // Include status for toggle functionality
          }
        ],
        'mode': mode,
      });
      
      final response = await request.postJson(
        '${api_constants.baseUrl}/schedule/api/availability/upsert/',
        jsonData,
      );
      
      return response;
    } catch (e) {
      throw Exception('Error saving availability: $e');
    }
  }

  /// Delete availability
  /// Maps to Django: POST /schedule/api/availability/delete/?id=<id>
  static Future<Map<String, dynamic>> deleteAvailability(
    CookieRequest request,
    int availabilityId,
  ) async {
    try {
      print('=== DELETE: Attempting to delete ID $availabilityId ===');
      
      final response = await request.post(
        '${api_constants.baseUrl}/schedule/api/availability/delete/?id=$availabilityId',
        {},
      );
      
      print('Delete response type: ${response.runtimeType}');
      print('Delete response: $response');
      
      // Handle empty or non-JSON response
      if (response == null || response.isEmpty) {
        print('Empty response, returning success');
        return {'success': true, 'message': 'Availability deleted'};
      }
      
      return response;
    } catch (e) {
      print('Delete error: $e');
      // If error is JSON parsing, consider it successful delete
      if (e.toString().contains('JSON') || e.toString().contains('Unexpected end')) {
        print('JSON error, returning success anyway');
        return {'success': true, 'message': 'Availability deleted'};
      }
      throw Exception('Error deleting availability: $e');
    }
  }

  /// Toggle availability status (active/inactive)
  static Future<Map<String, dynamic>> toggleAvailabilityStatus(
    CookieRequest request,
    CoachAvailability availability,
  ) async {
    try {
      final newStatus = availability.isActive ? 'inactive' : 'active';
      
      // For toggle, delete old and add new with different status
      await deleteAvailability(request, availability.id);
      
      return await upsertAvailability(
        request,
        date: availability.date,
        startTime: availability.startTime,
        endTime: availability.endTime,
        status: newStatus,
      );
    } catch (e) {
      throw Exception('Error toggling availability status: $e');
    }
  }

  /// Bulk create availabilities for multiple dates
  static Future<List<Map<String, dynamic>>> bulkCreateAvailabilities(
    CookieRequest request,
    List<DateTime> dates,
    String startTime,
    String endTime,
  ) async {
    final results = <Map<String, dynamic>>[];
    
    for (final date in dates) {
      try {
        final result = await upsertAvailability(
          request,
          date: date,
          startTime: startTime,
          endTime: endTime,
        );
        results.add(result);
      } catch (e) {
        results.add({
          'success': false,
          'date': date.toIso8601String(),
          'error': e.toString(),
        });
      }
    }
    
    return results;
  }

  /// Get availabilities for a specific date
  static Future<List<CoachAvailability>> getAvailabilitiesForDate(
    CookieRequest request,
    DateTime date,
  ) async {
    final availabilities = await getAvailabilities(
      request,
      startDate: date,
      endDate: date,
    );
    
    return availabilities.where((a) => 
      a.date.year == date.year &&
      a.date.month == date.month &&
      a.date.day == date.day
    ).toList();
  }

  /// Check if date has availability
  static Future<bool> hasAvailabilityOnDate(
    CookieRequest request,
    DateTime date,
  ) async {
    final availabilities = await getAvailabilitiesForDate(request, date);
    return availabilities.isNotEmpty;
  }
}
