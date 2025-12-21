/// Simple DateTime utility for WIB timezone (UTC+7)
/// No complex timezone conversion - just simple local time handling
class DateTimeUtils {
  /// Get current time in WIB
  /// Since device is assumed to be in WIB, just use DateTime.now()
  static DateTime nowWIB() {
    return DateTime.now();
  }
  
  /// Format date to YYYY-MM-DD string for API
  static String formatDateForAPI(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  /// Format time to HH:mm string for API
  static String formatTimeForAPI(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  /// Combine date and time string (HH:mm) to DateTime
  static DateTime combineDateTime(DateTime date, String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
  
  /// Parse date string (YYYY-MM-DD) to DateTime
  static DateTime parseDate(String dateString) {
    final parts = dateString.split('-');
    return DateTime(
      int.parse(parts[0]), // year
      int.parse(parts[1]), // month
      int.parse(parts[2]), // day
    );
  }
  
  /// Parse datetime string from API to local DateTime
  /// Strips timezone info and treats as local WIB time
  /// Example: "2025-12-20T20:00:00+07:00" → DateTime(2025, 12, 20, 20, 0)
  static DateTime parseFromAPI(String dateTimeString) {
    // Remove timezone info (anything after +/- or Z)
    String cleanString = dateTimeString;
    
    // Remove timezone offset like +07:00 or -05:00
    if (cleanString.contains('+')) {
      cleanString = cleanString.substring(0, cleanString.indexOf('+'));
    } else if (cleanString.contains('Z')) {
      cleanString = cleanString.substring(0, cleanString.indexOf('Z'));
    } else if (cleanString.lastIndexOf('-') > 10) {
      // Check if there's a - after date part (for negative timezone)
      final lastDash = cleanString.lastIndexOf('-');
      if (lastDash > 10) { // Date part is YYYY-MM-DD, so - after position 10 is timezone
        cleanString = cleanString.substring(0, lastDash);
      }
    }
    
    // Parse as local time
    return DateTime.parse(cleanString);
  }
  
  /// Check if datetime is in the past
  static bool isPast(DateTime dateTime) {
    return dateTime.isBefore(nowWIB());
  }
  
  /// Check if datetime is today
  static bool isToday(DateTime dateTime) {
    final now = nowWIB();
    return dateTime.year == now.year &&
           dateTime.month == now.month &&
           dateTime.day == now.day;
  }
  
  /// Get hours until specific datetime
  static int hoursUntil(DateTime dateTime) {
    return dateTime.difference(nowWIB()).inHours;
  }
  
  /// Get minutes until specific datetime
  static int minutesUntil(DateTime dateTime) {
    return dateTime.difference(nowWIB()).inMinutes;
  }
}
