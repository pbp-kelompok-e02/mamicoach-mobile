import 'package:flutter/foundation.dart';
import '../models/coach_model.dart';
import '../services/admin_api_service.dart';

/// Coach Provider for MamiCoach Admin Panel
class CoachProvider extends ChangeNotifier {
  final AdminApiService _apiService = AdminApiService();
  
  List<Coach> _coaches = [];
  CoachPagination? _pagination;
  bool _isLoading = false;
  String? _error;
  
  // Filter state
  String _statusFilter = 'all';
  String _searchQuery = '';
  int _currentPage = 1;
  int _perPage = 10;

  // Getters
  List<Coach> get coaches => _coaches;
  CoachPagination? get pagination => _pagination;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get statusFilter => _statusFilter;
  String get searchQuery => _searchQuery;

  /// Fetch coaches with optional filtering
  Future<void> fetchCoaches({
    String? status,
    String? search,
    int? page,
    int? perPage,
  }) async {
    _isLoading = true;
    _error = null;
    
    if (status != null) _statusFilter = status;
    if (search != null) _searchQuery = search;
    if (page != null) _currentPage = page;
    if (perPage != null) _perPage = perPage;
    
    notifyListeners();

    try {
      final response = await _apiService.getCoaches(
        status: _statusFilter,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        page: _currentPage,
        perPage: _perPage,
      );

      if (response['status'] == true) {
        final data = response['data'];
        final coachesList = data['coaches'] as List<dynamic>? ?? [];
        _coaches = coachesList.map((json) => Coach.fromJson(json)).toList();
        
        if (data['pagination'] != null) {
          _pagination = CoachPagination.fromJson(data['pagination']);
        }
      } else {
        _error = response['message'] ?? 'Failed to fetch coaches';
        _coaches = [];
      }
    } catch (e) {
      debugPrint('Error fetching coaches: $e');
      _error = 'Terjadi kesalahan: ${e.toString()}';
      _coaches = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Reset filters
  void resetFilters() {
    _statusFilter = 'all';
    _searchQuery = '';
    _currentPage = 1;
    notifyListeners();
  }
}
