class Payment {
  final int id;
  final int bookingId;
  final int userId;
  final int amount;
  final String method;
  final String orderId;
  final String? transactionId;
  final String? transactionRef;
  final String status;
  final String? paymentUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? paidAt;
  final Map<String, dynamic>? midtransResponse;

  Payment({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.amount,
    required this.method,
    required this.orderId,
    this.transactionId,
    this.transactionRef,
    required this.status,
    this.paymentUrl,
    required this.createdAt,
    required this.updatedAt,
    this.paidAt,
    this.midtransResponse,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      bookingId: json['booking_id'],
      userId: json['user_id'],
      amount: json['amount'],
      method: json['method'],
      orderId: json['order_id'],
      transactionId: json['transaction_id'],
      transactionRef: json['transaction_ref'],
      status: json['status'],
      paymentUrl: json['payment_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      midtransResponse: json['midtrans_response'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'user_id': userId,
      'amount': amount,
      'method': method,
      'order_id': orderId,
      'transaction_id': transactionId,
      'transaction_ref': transactionRef,
      'status': status,
      'payment_url': paymentUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'midtrans_response': midtransResponse,
    };
  }
}

class PaymentResponse {
  final bool success;
  final int? paymentId;
  final String? redirectUrl;
  final String? token;
  final String? error;

  PaymentResponse({
    required this.success,
    this.paymentId,
    this.redirectUrl,
    this.token,
    this.error,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      success: json['success'] ?? false,
      paymentId: json['payment_id'],
      redirectUrl: json['redirect_url'],
      token: json['token'],
      error: json['error'],
    );
  }
}

class PaymentStatusResponse {
  final bool success;
  final int paymentId;
  final String orderId;
  final String status;
  final bool isSuccessful;
  final bool isPending;
  final bool isFailed;
  final int amount;
  final String method;
  final int bookingId;
  final String bookingStatus;

  PaymentStatusResponse({
    required this.success,
    required this.paymentId,
    required this.orderId,
    required this.status,
    required this.isSuccessful,
    required this.isPending,
    required this.isFailed,
    required this.amount,
    required this.method,
    required this.bookingId,
    required this.bookingStatus,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      success: json['success'] ?? false,
      paymentId: json['payment_id'],
      orderId: json['order_id'],
      status: json['status'],
      isSuccessful: json['is_successful'] ?? false,
      isPending: json['is_pending'] ?? false,
      isFailed: json['is_failed'] ?? false,
      amount: json['amount'],
      method: json['method'],
      bookingId: json['booking_id'],
      bookingStatus: json['booking_status'],
    );
  }
}

class PaymentMethod {
  final String code;
  final String displayName;
  final String midtransType;
  final String category; // e-wallet, virtual_account, credit_card, etc.
  final String? iconAsset;

  PaymentMethod({
    required this.code,
    required this.displayName,
    required this.midtransType,
    required this.category,
    this.iconAsset,
  });

  static List<PaymentMethod> getAllMethods() {
    return [
      // E-Wallets
      PaymentMethod(
        code: 'gopay',
        displayName: 'GO-PAY',
        midtransType: 'gopay',
        category: 'e-wallet',
      ),
      PaymentMethod(
        code: 'shopeepay',
        displayName: 'ShopeePay',
        midtransType: 'shopeepay',
        category: 'e-wallet',
      ),
      PaymentMethod(
        code: 'dana',
        displayName: 'Dana',
        midtransType: 'dana',
        category: 'e-wallet',
      ),
      PaymentMethod(
        code: 'qris',
        displayName: 'QRIS',
        midtransType: 'qris',
        category: 'qr-code',
      ),
      
      // Virtual Accounts
      PaymentMethod(
        code: 'bca_va',
        displayName: 'BCA Virtual Account',
        midtransType: 'bca_va',
        category: 'virtual_account',
      ),
      PaymentMethod(
        code: 'mandiri_va',
        displayName: 'Mandiri Virtual Account',
        midtransType: 'echannel',
        category: 'virtual_account',
      ),
      PaymentMethod(
        code: 'bni_va',
        displayName: 'BNI Virtual Account',
        midtransType: 'bni_va',
        category: 'virtual_account',
      ),
      PaymentMethod(
        code: 'bri_va',
        displayName: 'BRI Virtual Account',
        midtransType: 'bri_va',
        category: 'virtual_account',
      ),
      PaymentMethod(
        code: 'permata_va',
        displayName: 'Permata Virtual Account',
        midtransType: 'permata_va',
        category: 'virtual_account',
      ),
      PaymentMethod(
        code: 'cimb_va',
        displayName: 'CIMB Virtual Account',
        midtransType: 'cimb_va',
        category: 'virtual_account',
      ),
      PaymentMethod(
        code: 'danamon_va',
        displayName: 'Danamon Virtual Account',
        midtransType: 'danamon_va',
        category: 'virtual_account',
      ),
      PaymentMethod(
        code: 'bsi_va',
        displayName: 'BSI Virtual Account',
        midtransType: 'bsi_va',
        category: 'virtual_account',
      ),
      PaymentMethod(
        code: 'other_va',
        displayName: 'Other Virtual Account',
        midtransType: 'other_va',
        category: 'virtual_account',
      ),
      
      // Credit Card
      PaymentMethod(
        code: 'credit_card',
        displayName: 'Credit Card',
        midtransType: 'credit_card',
        category: 'credit_card',
      ),
      
      // Convenience Store
      PaymentMethod(
        code: 'indomaret',
        displayName: 'Indomaret',
        midtransType: 'cstore',
        category: 'convenience_store',
      ),
      PaymentMethod(
        code: 'alfamart',
        displayName: 'Alfamart',
        midtransType: 'cstore',
        category: 'convenience_store',
      ),
      
      // Installment
      PaymentMethod(
        code: 'akulaku',
        displayName: 'Akulaku',
        midtransType: 'akulaku',
        category: 'installment',
      ),
      PaymentMethod(
        code: 'kredivo',
        displayName: 'Kredivo',
        midtransType: 'kredivo',
        category: 'installment',
      ),
    ];
  }

  static List<PaymentMethod> getMethodsByCategory(String category) {
    return getAllMethods().where((method) => method.category == category).toList();
  }
}
