import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// Utility class for timezone conversions (WIB = UTC+7)
class TimezoneUtils {
  static final tz.Location _wibLocation = tz.getLocation('Asia/Jakarta');
  static bool _initialized = false;

  /// Initialize timezone data
  static void initialize() {
    if (!_initialized) {
      tz.initializeTimeZones();
      _initialized = true;
    }
  }

  /// Get current time in WIB (UTC+7)
  static DateTime nowWIB() {
    initialize();
    return tz.TZDateTime.now(_wibLocation);
  }

  /// Convert DateTime to WIB
  static DateTime toWIB(DateTime dateTime) {
    initialize();
    if (dateTime.isUtc) {
      return tz.TZDateTime.from(dateTime, _wibLocation);
    }
    // Assume it's already in local time, convert to WIB
    final utcTime = dateTime.toUtc();
    return tz.TZDateTime.from(utcTime, _wibLocation);
  }

  /// Convert WIB DateTime to UTC for API calls
  static DateTime toUTC(DateTime dateTime) {
    initialize();
    final wibTime = tz.TZDateTime.from(dateTime, _wibLocation);
    return wibTime.toUtc();
  }

  /// Parse ISO string from backend (assumes UTC) and convert to WIB
  static DateTime parseToWIB(String isoString) {
    initialize();
    final utcTime = DateTime.parse(isoString).toUtc();
    return tz.TZDateTime.from(utcTime, _wibLocation);
  }

  /// Format DateTime to ISO string in UTC for API calls
  static String toISOString(DateTime dateTime) {
    final utcTime = toUTC(dateTime);
    return utcTime.toIso8601String();
  }

  /// Combine date and time in WIB timezone
  static DateTime combineWIB(DateTime date, String timeString) {
    initialize();
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    return tz.TZDateTime(
      _wibLocation,
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }

  /// Check if date is in the past (WIB timezone)
  static bool isPast(DateTime dateTime) {
    final wibTime = toWIB(dateTime);
    final now = nowWIB();
    return wibTime.isBefore(now);
  }

  /// Check if date is today (WIB timezone)
  static bool isToday(DateTime dateTime) {
    final wibTime = toWIB(dateTime);
    final now = nowWIB();
    return wibTime.year == now.year &&
           wibTime.month == now.month &&
           wibTime.day == now.day;
  }

  /// Get timezone offset string (e.g., "+07:00")
  static String get offsetString => '+07:00';
  
  /// Get timezone name
  static String get timezoneName => 'WIB (UTC+7)';

  /// Test method to verify timezone is working correctly
  static void runTimezoneTest() {
    initialize();
    
    print('=== TIMEZONE TEST ===');
    
    // Test 1: Current time
    final now = nowWIB();
    print('1. Current WIB Time: $now');
    print('   Offset from UTC: ${now.timeZoneOffset.inHours} hours');
    
    // Test 2: Compare with device time
    final deviceTime = DateTime.now();
    print('2. Device Time: $deviceTime');
    print('   Device Offset: ${deviceTime.timeZoneOffset.inHours} hours');
    
    // Test 3: Convert UTC to WIB
    final utcTime = DateTime.utc(2025, 12, 19, 10, 0); // 10:00 UTC
    final wibTime = toWIB(utcTime);
    print('3. UTC: $utcTime → WIB: $wibTime');
    print('   Expected: 17:00 WIB (10:00 + 7 hours)');
    
    // Test 4: Convert WIB to UTC
    final testWibTime = tz.TZDateTime(_wibLocation, 2025, 12, 19, 15, 30);
    final backToUtc = toUTC(testWibTime);
    print('4. WIB: $testWibTime → UTC: $backToUtc');
    print('   Expected: 08:30 UTC (15:30 - 7 hours)');
    
    // Test 5: Combine date and time
    final combinedTime = combineWIB(DateTime(2025, 12, 25), '14:30');
    print('5. Combined: Date(2025-12-25) + Time(14:30) = $combinedTime');
    print('   Expected: 2025-12-25 14:30 WIB');
    
    // Test 6: ISO String conversion
    final isoString = toISOString(combinedTime);
    print('6. ISO String (for API): $isoString');
    print('   Expected: 2025-12-25T07:30:00.000Z (14:30 WIB = 07:30 UTC)');
    
    // Test 7: Parse from API
    final apiResponse = '2025-12-25T10:00:00Z'; // UTC from backend
    final parsedWib = parseToWIB(apiResponse);
    print('7. Parse from API: $apiResponse → $parsedWib');
    print('   Expected: 2025-12-25 17:00 WIB (10:00 UTC + 7 hours)');
    
    // Test 8: isPast logic (jadwal terlewat)
    final todayDate = DateTime(now.year, now.month, now.day);
    final pastSchedule = combineWIB(todayDate, '${(now.hour - 1).toString().padLeft(2, '0')}:00');
    final futureSchedule = combineWIB(todayDate, '${(now.hour + 1).toString().padLeft(2, '0')}:00');
    print('8. isPast Test:');
    print('   Now: ${now.hour}:${now.minute}');
    print('   Past schedule (${now.hour - 1}:00): ${isPast(pastSchedule)} (should be true)');
    print('   Future schedule (${now.hour + 1}:00): ${isPast(futureSchedule)} (should be false)');
    
    print('=== TEST COMPLETED ===\n');
  }
}

