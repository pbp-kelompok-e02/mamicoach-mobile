class CoachAvailability {
  final int id;
  final int coachId;
  final DateTime date;
  final String startTime; // Format: "HH:mm"
  final String endTime; // Format: "HH:mm"
  final String status; // 'active' or 'inactive'
  final DateTime createdAt;
  final DateTime updatedAt;

  CoachAvailability({
    required this.id,
    required this.coachId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CoachAvailability.fromJson(Map<String, dynamic> json) {
    return CoachAvailability(
      id: json['id'],
      coachId: json['coach_id'],
      date: DateTime.parse(json['date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coach_id': coachId,
      'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
    };
  }

  String get dateFormatted {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String get timeRangeFormatted {
    return '$startTime - $endTime';
  }

  String get dayName {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return days[date.weekday - 1];
  }

  bool get isActive => status == 'active';

  bool get isPast => date.isBefore(DateTime.now());

  CoachAvailability copyWith({
    int? id,
    int? coachId,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoachAvailability(
      id: id ?? this.id,
      coachId: coachId ?? this.coachId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
