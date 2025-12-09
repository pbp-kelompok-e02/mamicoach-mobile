import 'package:flutter/foundation.dart';
import '../models/payment.dart';
import '../services/admin_api_service.dart';

/// Payment Provider for MamiCoach Admin Panel
class PaymentProvider extends ChangeNotifier {
  final AdminApiService _apiService = AdminApiService();
  
  List<Payment> _payments = [];
  Payment? _selectedPayment;
  PaymentPagination? _pagination;
  bool _isLoading = false;
  String? _error;
  String _currentFilter = 'all';
  String _searchQuery = '';

  // Getters
  List<Payment> get payments => _payments;
  Payment? get selectedPayment => _selectedPayment;
  PaymentPagination? get pagination => _pagination;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;

  /// Fetch payments with optional filtering
  Future<void> fetchPayments({
    String status = 'all',
    String? search,
    int page = 1,
    int perPage = 10,
  }) async {
    _isLoading = true;
    _error = null;
    _currentFilter = status;
    if (search != null) _searchQuery = search;
    notifyListeners();

    try {
      final response = await _apiService.getPayments(
        status: status,
        search: search,
        page: page,
        perPage: perPage,
      );

      if (response['status'] == true) {
        final data = response['data'];
        final paymentsList = data['payments'] as List<dynamic>? ?? [];
        _payments = paymentsList.map((json) => Payment.fromJson(json)).toList();
        
        if (data['pagination'] != null) {
          _pagination = PaymentPagination.fromJson(data['pagination']);
        }
      } else {
        _error = response['message'] ?? 'Failed to fetch payments';
        // Use mock data for demo
        _payments = _getMockPayments();
      }
    } catch (e) {
      debugPrint('Error fetching payments: $e');
      _error = 'Terjadi kesalahan: ${e.toString()}';
      // Use mock data for demo
      _payments = _getMockPayments();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Get payment detail
  Future<Payment?> getPaymentDetail(int paymentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getPaymentDetail(paymentId);

      if (response['status'] == true) {
        _selectedPayment = Payment.fromJson(response['data']);
        _isLoading = false;
        notifyListeners();
        return _selectedPayment;
      } else {
        _error = response['message'] ?? 'Payment not found';
      }
    } catch (e) {
      debugPrint('Error fetching payment detail: $e');
      _error = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return null;
  }

  /// Update payment status
  Future<bool> updatePaymentStatus(int paymentId, String newStatus) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.updatePaymentStatus(paymentId, newStatus);

      if (response['status'] == true) {
        // Refresh the list to get updated data
        await fetchPayments(
          status: _currentFilter,
          search: _searchQuery.isNotEmpty ? _searchQuery : null,
        );
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to update payment status';
      }
    } catch (e) {
      debugPrint('Error updating payment status: $e');
      _error = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Clear selected payment
  void clearSelectedPayment() {
    _selectedPayment = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh payments
  Future<void> refresh() async {
    await fetchPayments(
      status: _currentFilter,
      search: _searchQuery.isNotEmpty ? _searchQuery : null,
    );
  }

  /// Get statistics for payments
  Map<String, int> getPaymentStats() {
    int pending = 0;
    int successful = 0;
    int failed = 0;

    for (final payment in _payments) {
      if (PaymentStatus.isPending(payment.status)) {
        pending++;
      } else if (PaymentStatus.isSuccessful(payment.status)) {
        successful++;
      } else if (PaymentStatus.isFailed(payment.status)) {
        failed++;
      }
    }

    return {
      'pending': pending,
      'successful': successful,
      'failed': failed,
      'total': _payments.length,
    };
  }

  /// Get total revenue from successful payments
  int getTotalRevenue() {
    return _payments
        .where((p) => PaymentStatus.isSuccessful(p.status))
        .fold(0, (sum, p) => sum + p.amount);
  }

  /// Get mock payments for demo
  List<Payment> _getMockPayments() {
    return [
      Payment(
        id: 1,
        orderId: 'MC-1702000001',
        transactionId: 'txn_abc123',
        booking: PaymentBooking(
          id: 1,
          user: PaymentUser(id: 1, username: 'john_doe'),
          course: PaymentCourse(id: 1, title: 'Yoga untuk Pemula'),
        ),
        amount: 150000,
        method: 'gopay',
        methodDisplay: 'GO-PAY',
        status: 'settlement',
        isSuccessful: true,
        isPending: false,
        isFailed: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
        paidAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Payment(
        id: 2,
        orderId: 'MC-1702000002',
        booking: PaymentBooking(
          id: 2,
          user: PaymentUser(id: 2, username: 'jane_smith'),
          course: PaymentCourse(id: 2, title: 'Fitness Training'),
        ),
        amount: 200000,
        method: 'bca_va',
        methodDisplay: 'BCA Virtual Account',
        status: 'pending',
        isSuccessful: false,
        isPending: true,
        isFailed: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Payment(
        id: 3,
        orderId: 'MC-1702000003',
        transactionId: 'txn_xyz789',
        booking: PaymentBooking(
          id: 3,
          user: PaymentUser(id: 3, username: 'alice_wonder'),
          course: PaymentCourse(id: 3, title: 'Meditasi Harian'),
        ),
        amount: 100000,
        method: 'shopeepay',
        methodDisplay: 'ShopeePay',
        status: 'expire',
        isSuccessful: false,
        isPending: false,
        isFailed: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
