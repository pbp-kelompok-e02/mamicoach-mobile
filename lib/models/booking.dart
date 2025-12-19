class Booking {
  final int id;
  final int userId;
  final int courseId;
  final int coachId;
  final String courseTitle;
  final String userName;
  final String coachName;
  final DateTime startDatetime;
  final DateTime endDatetime;
  final String status; // pending, paid, confirmed, done, canceled
  final double price;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.coachId,
    required this.courseTitle,
    required this.userName,
    required this.coachName,
    required this.startDatetime,
    required this.endDatetime,
    required this.status,
    required this.price,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      courseId: json['course_id'],
      coachId: json['coach_id'],
      courseTitle: json['course_title'],
      userName: json['user_name'] ?? '',
      coachName: json['coach_name'],
      startDatetime: DateTime.parse(json['start_datetime']),
      endDatetime: DateTime.parse(json['end_datetime']),
      status: json['status'],
      price: (json['price'] is int) 
          ? (json['price'] as int).toDouble() 
          : json['price'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'coach_id': coachId,
      'start_datetime': startDatetime.toIso8601String(),
      'end_datetime': endDatetime.toIso8601String(),
    };
  }

  String get priceFormatted {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
  
  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'paid':
        return 'Sudah Dibayar';
      case 'confirmed':
        return 'Dikonfirmasi Coach';
      case 'done':
        return 'Selesai';
      case 'canceled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  String get dateTimeFormatted {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    
    return '${startDatetime.day} ${months[startDatetime.month - 1]} ${startDatetime.year} • '
           '${startDatetime.hour.toString().padLeft(2, '0')}:${startDatetime.minute.toString().padLeft(2, '0')} - '
           '${endDatetime.hour.toString().padLeft(2, '0')}:${endDatetime.minute.toString().padLeft(2, '0')}';
  }

  String get dateFormatted {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${startDatetime.day} ${months[startDatetime.month - 1]} ${startDatetime.year}';
  }

  String get timeFormatted {
    return '${startDatetime.hour.toString().padLeft(2, '0')}:${startDatetime.minute.toString().padLeft(2, '0')} - '
           '${endDatetime.hour.toString().padLeft(2, '0')}:${endDatetime.minute.toString().padLeft(2, '0')}';
  }
}
