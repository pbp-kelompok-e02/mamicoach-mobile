/// Utility class for booking payment rules and deadlines
class BookingPaymentUtils {
  // Minimum hours before class to allow booking
  static const int minHoursBeforeClass = 1;
  
  // Grace period: 24 jam untuk bayar jika book jauh-jauh hari
  static const int maxGracePeriodHours = 24;
  
  // Payment deadline: 30 menit sebelum kelas dimulai
  static const int paymentDeadlineMinutes = 30;
  
  /// Check if user can book this class (apakah masih cukup waktu untuk bayar)
  static bool canBook(DateTime classStartTime) {
    final now = DateTime.now();
    final hoursUntilClass = classStartTime.difference(now).inHours;
    
    // Harus ada minimal 1 jam sebelum kelas untuk booking
    return hoursUntilClass >= minHoursBeforeClass;
  }
  
  /// Calculate payment deadline untuk booking
  static DateTime calculatePaymentDeadline(DateTime classStartTime) {
    final now = DateTime.now();
    final hoursUntilClass = classStartTime.difference(now).inHours;
    
    if (hoursUntilClass > maxGracePeriodHours) {
      // Kelas masih lama: user punya 24 jam untuk bayar
      return now.add(const Duration(hours: maxGracePeriodHours));
    } else {
      // Kelas dekat: harus bayar 30 menit sebelum kelas dimulai
      return classStartTime.subtract(const Duration(minutes: paymentDeadlineMinutes));
    }
  }
  
  /// Check if payment deadline has passed
  static bool isPaymentExpired(DateTime paymentDeadline) {
    final now = DateTime.now();
    return now.isAfter(paymentDeadline);
  }
  
  /// Get human-readable payment deadline message
  static String getPaymentDeadlineMessage(DateTime classStartTime) {
    final deadline = calculatePaymentDeadline(classStartTime);
    final now = DateTime.now();
    final hoursRemaining = deadline.difference(now).inHours;
    final minutesRemaining = deadline.difference(now).inMinutes % 60;
    
    if (hoursRemaining > 24) {
      final daysRemaining = hoursRemaining ~/ 24;
      return 'Selesaikan pembayaran dalam $daysRemaining hari';
    } else if (hoursRemaining > 0) {
      return 'Selesaikan pembayaran dalam $hoursRemaining jam ${minutesRemaining > 0 ? "$minutesRemaining menit" : ""}';
    } else if (minutesRemaining > 0) {
      return 'Selesaikan pembayaran dalam $minutesRemaining menit';
    } else {
      return 'Waktu pembayaran habis';
    }
  }
  
  /// Format deadline as string
  static String formatDeadline(DateTime deadline) {
    return '${deadline.day} ${_getMonthName(deadline.month)} ${deadline.year}, '
           '${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')} WIB';
  }
  
  static String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month];
  }
  
  /// Get time remaining until class in human-readable format
  static String getTimeUntilClass(DateTime classStartTime) {
    final now = DateTime.now();
    final diff = classStartTime.difference(now);
    
    if (diff.inDays > 0) {
      return '${diff.inDays} hari lagi';
    } else if (diff.inHours > 0) {
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      return '$hours jam ${minutes > 0 ? "$minutes menit " : ""}lagi';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} menit lagi';
    } else {
      return 'Sudah dimulai';
    }
  }
}
