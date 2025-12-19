import 'package:flutter/foundation.dart';
import '../models/booking.dart';
import '../services/admin_api_service.dart';

/// Booking Provider for MamiCoach Admin Panel
class BookingProvider extends ChangeNotifier {
  final AdminApiService _apiService = AdminApiService();
  
  List<Booking> _bookings = [];
  Booking? _selectedBooking;
  BookingPagination? _pagination;
  bool _isLoading = false;
  String? _error;
  String _currentFilter = 'all';
  String _searchQuery = '';

  // Getters
  List<Booking> get bookings => _bookings;
  Booking? get selectedBooking => _selectedBooking;
  BookingPagination? get pagination => _pagination;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;

  /// Fetch bookings with optional filtering
  Future<void> fetchBookings({
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
      final response = await _apiService.getBookings(
        status: status,
        search: search,
        page: page,
        perPage: perPage,
      );

      if (response['status'] == true) {
        final data = response['data'];
        final bookingsList = data['bookings'] as List<dynamic>? ?? [];
        _bookings = bookingsList.map((json) => Booking.fromJson(json)).toList();
        
        if (data['pagination'] != null) {
          _pagination = BookingPagination.fromJson(data['pagination']);
        }
      } else {
        _error = response['message'] ?? 'Failed to fetch bookings';
        // Use mock data for demo
        _bookings = _getMockBookings();
      }
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
      _error = 'Terjadi kesalahan: ${e.toString()}';
      // Use mock data for demo
      _bookings = _getMockBookings();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Get booking detail
  Future<Booking?> getBookingDetail(int bookingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getBookingDetail(bookingId);

      if (response['status'] == true) {
        _selectedBooking = Booking.fromJson(response['data']);
        _isLoading = false;
        notifyListeners();
        return _selectedBooking;
      } else {
        _error = response['message'] ?? 'Booking not found';
      }
    } catch (e) {
      debugPrint('Error fetching booking detail: $e');
      _error = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return null;
  }

  /// Update booking status
  Future<bool> updateBookingStatus(int bookingId, String newStatus) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.updateBookingStatus(bookingId, newStatus);

      if (response['status'] == true) {
        // Update local booking list
        final index = _bookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          // Refresh the list to get updated data
          await fetchBookings(
            status: _currentFilter,
            search: _searchQuery.isNotEmpty ? _searchQuery : null,
          );
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to update booking status';
      }
    } catch (e) {
      debugPrint('Error updating booking status: $e');
      _error = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Delete booking
  Future<bool> deleteBooking(int bookingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.deleteBooking(bookingId);

      if (response['status'] == true) {
        // Remove from local list
        _bookings.removeWhere((b) => b.id == bookingId);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to delete booking';
      }
    } catch (e) {
      debugPrint('Error deleting booking: $e');
      _error = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Clear selected booking
  void clearSelectedBooking() {
    _selectedBooking = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh bookings
  Future<void> refresh() async {
    await fetchBookings(
      status: _currentFilter,
      search: _searchQuery.isNotEmpty ? _searchQuery : null,
    );
  }

  /// Get mock bookings for demo
  List<Booking> _getMockBookings() {
    return [
      Booking(
        id: 1,
        user: BookingUser(id: 1, username: 'john_doe', email: 'john@example.com'),
        coach: BookingCoach(id: 1, name: 'Coach Sarah'),
        course: BookingCourse(id: 1, title: 'Yoga untuk Pemula', price: 150000),
        startDatetime: DateTime.now().add(const Duration(days: 2)),
        endDatetime: DateTime.now().add(const Duration(days: 2, hours: 1)),
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Booking(
        id: 2,
        user: BookingUser(id: 2, username: 'jane_smith', email: 'jane@example.com'),
        coach: BookingCoach(id: 2, name: 'Coach Mike'),
        course: BookingCourse(id: 2, title: 'Fitness Training', price: 200000),
        startDatetime: DateTime.now().add(const Duration(days: 1)),
        endDatetime: DateTime.now().add(const Duration(days: 1, hours: 1)),
        status: 'paid',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Booking(
        id: 3,
        user: BookingUser(id: 3, username: 'alice_wonder', email: 'alice@example.com'),
        coach: BookingCoach(id: 3, name: 'Coach Lisa'),
        course: BookingCourse(id: 3, title: 'Meditasi Harian', price: 100000),
        startDatetime: DateTime.now().subtract(const Duration(days: 1)),
        endDatetime: DateTime.now().subtract(const Duration(days: 1)).add(const Duration(hours: 1)),
        status: 'done',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
