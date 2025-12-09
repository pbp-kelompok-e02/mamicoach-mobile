/// Payment Model for MamiCoach Admin Panel
class Payment {
  final int id;
  final String orderId;
  final String? transactionId;
  final String? transactionRef;
  final PaymentBooking? booking;
  final PaymentUser? user;
  final int amount;
  final String method;
  final String methodDisplay;
  final String status;
  final bool isSuccessful;
  final bool isPending;
  final bool isFailed;
  final String? paymentUrl;
  final Map<String, dynamic>? midtransResponse;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? paidAt;

  Payment({
    required this.id,
    required this.orderId,
    this.transactionId,
    this.transactionRef,
    this.booking,
    this.user,
    required this.amount,
    required this.method,
    required this.methodDisplay,
    required this.status,
    required this.isSuccessful,
    required this.isPending,
    required this.isFailed,
    this.paymentUrl,
    this.midtransResponse,
    required this.createdAt,
    required this.updatedAt,
    this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? '',
      transactionId: json['transaction_id'],
      transactionRef: json['transaction_ref'],
      booking: json['booking'] != null ? PaymentBooking.fromJson(json['booking']) : null,
      user: json['user'] != null ? PaymentUser.fromJson(json['user']) : null,
      amount: json['amount'] ?? 0,
      method: json['method'] ?? '',
      methodDisplay: json['method_display'] ?? json['method'] ?? '',
      status: json['status'] ?? 'pending',
      isSuccessful: json['is_successful'] ?? false,
      isPending: json['is_pending'] ?? true,
      isFailed: json['is_failed'] ?? false,
      paymentUrl: json['payment_url'],
      midtransResponse: json['midtrans_response'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      paidAt: json['paid_at'] != null ? DateTime.tryParse(json['paid_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_id': orderId,
    'transaction_id': transactionId,
    'transaction_ref': transactionRef,
    'booking': booking?.toJson(),
    'user': user?.toJson(),
    'amount': amount,
    'method': method,
    'method_display': methodDisplay,
    'status': status,
    'is_successful': isSuccessful,
    'is_pending': isPending,
    'is_failed': isFailed,
    'payment_url': paymentUrl,
    'midtrans_response': midtransResponse,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'paid_at': paidAt?.toIso8601String(),
  };

  /// Get display name for status
  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'settlement':
        return 'Berhasil';
      case 'capture':
        return 'Berhasil (CC)';
      case 'deny':
        return 'Ditolak';
      case 'cancel':
        return 'Dibatalkan';
      case 'expire':
        return 'Kedaluwarsa';
      case 'failure':
        return 'Gagal';
      default:
        return status;
    }
  }

  /// Create a copy with updated fields
  Payment copyWith({
    int? id,
    String? orderId,
    String? transactionId,
    String? transactionRef,
    PaymentBooking? booking,
    PaymentUser? user,
    int? amount,
    String? method,
    String? methodDisplay,
    String? status,
    bool? isSuccessful,
    bool? isPending,
    bool? isFailed,
    String? paymentUrl,
    Map<String, dynamic>? midtransResponse,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? paidAt,
  }) {
    return Payment(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      transactionId: transactionId ?? this.transactionId,
      transactionRef: transactionRef ?? this.transactionRef,
      booking: booking ?? this.booking,
      user: user ?? this.user,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      methodDisplay: methodDisplay ?? this.methodDisplay,
      status: status ?? this.status,
      isSuccessful: isSuccessful ?? this.isSuccessful,
      isPending: isPending ?? this.isPending,
      isFailed: isFailed ?? this.isFailed,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      midtransResponse: midtransResponse ?? this.midtransResponse,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}

/// Generic Pagination class
class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;
  final bool hasNext;
  final bool hasPrevious;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalItems: json['total_items'] ?? 0,
      perPage: json['per_page'] ?? 10,
      hasNext: json['has_next'] ?? false,
      hasPrevious: json['has_previous'] ?? false,
    );
  }
}

class PaymentBooking {
  final int id;
  final PaymentUser? user;
  final PaymentCourse? course;
  final String? status;

  PaymentBooking({
    required this.id,
    this.user,
    this.course,
    this.status,
  });

  factory PaymentBooking.fromJson(Map<String, dynamic> json) {
    return PaymentBooking(
      id: json['id'] ?? 0,
      user: json['user'] != null ? PaymentUser.fromJson(json['user']) : null,
      course: json['course'] != null ? PaymentCourse.fromJson(json['course']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user?.toJson(),
    'course': course?.toJson(),
    'status': status,
  };
}

class PaymentUser {
  final int id;
  final String username;
  final String? email;

  PaymentUser({
    required this.id,
    required this.username,
    this.email,
  });

  factory PaymentUser.fromJson(Map<String, dynamic> json) {
    return PaymentUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
  };
}

class PaymentCourse {
  final int id;
  final String title;
  final double? price;

  PaymentCourse({
    required this.id,
    required this.title,
    this.price,
  });

  factory PaymentCourse.fromJson(Map<String, dynamic> json) {
    return PaymentCourse(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: json['price']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
  };
}

/// Pagination info for payment list
class PaymentPagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;
  final bool hasNext;
  final bool hasPrevious;

  PaymentPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaymentPagination.fromJson(Map<String, dynamic> json) {
    return PaymentPagination(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalItems: json['total_items'] ?? 0,
      perPage: json['per_page'] ?? 10,
      hasNext: json['has_next'] ?? false,
      hasPrevious: json['has_previous'] ?? false,
    );
  }
}

/// Valid payment statuses
class PaymentStatus {
  static const String pending = 'pending';
  static const String settlement = 'settlement';
  static const String capture = 'capture';
  static const String deny = 'deny';
  static const String cancel = 'cancel';
  static const String expire = 'expire';
  static const String failure = 'failure';

  static const List<String> all = [pending, settlement, capture, deny, cancel, expire, failure];
  static const List<String> successful = [settlement, capture];
  static const List<String> failed = [deny, cancel, expire, failure];

  static String getDisplayName(String status) {
    switch (status) {
      case pending:
        return 'Menunggu';
      case settlement:
        return 'Berhasil';
      case capture:
        return 'Berhasil (CC)';
      case deny:
        return 'Ditolak';
      case cancel:
        return 'Dibatalkan';
      case expire:
        return 'Kedaluwarsa';
      case failure:
        return 'Gagal';
      default:
        return status;
    }
  }

  static bool isSuccessful(String status) => successful.contains(status);
  static bool isFailed(String status) => failed.contains(status);
  static bool isPending(String status) => status == pending;
}

/// Payment method codes and display names
class PaymentMethod {
  static const Map<String, String> methods = {
    'credit_card': 'Credit Card',
    'bca_va': 'BCA Virtual Account',
    'mandiri_va': 'Mandiri Virtual Account',
    'bni_va': 'BNI Virtual Account',
    'bri_va': 'BRI Virtual Account',
    'permata_va': 'Permata Virtual Account',
    'cimb_va': 'CIMB Virtual Account',
    'other_va': 'Other Virtual Account',
    'indomaret': 'Indomaret',
    'alfamart': 'Alfamart',
    'gopay': 'GO-PAY',
    'shopeepay': 'ShopeePay',
    'dana': 'Dana',
    'qris': 'QRIS',
    'kredivo': 'Kredivo',
    'akulaku': 'Akulaku',
  };

  static String getDisplayName(String method) {
    return methods[method] ?? method;
  }
}
