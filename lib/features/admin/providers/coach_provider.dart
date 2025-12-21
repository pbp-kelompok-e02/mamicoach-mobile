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
  bool _isLoadingMore = false;

  // Getters
  List<Coach> get coaches => _coaches;
  CoachPagination? get pagination => _pagination;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get statusFilter => _statusFilter;
  String get searchQuery => _searchQuery;
  bool get hasMore => _pagination?.hasNext ?? false;
  bool get isLoadingMore => _isLoadingMore;

  /// Fetch coaches with optional filtering
  Future<void> fetchCoaches({
    String? status,
    String? search,
    int? page,
    int? perPage,
  }) async {
    debugPrint('[ADMIN COACH PROVIDER] 🔄 Starting coaches fetch...');
    _isLoading = true;
    _error = null;
    
    if (status != null) _statusFilter = status;
    if (search != null) _searchQuery = search;
    if (page != null) _currentPage = page;
    if (perPage != null) _perPage = perPage;
    
    debugPrint('[ADMIN COACH PROVIDER] 🔍 Filters - status: $_statusFilter, page: $_currentPage, search: "$_searchQuery"');
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
        debugPrint('[ADMIN COACH PROVIDER] ✅ Coaches fetched successfully: ${_coaches.length} coaches');
      } else {
        _error = response['message'] ?? 'Failed to fetch coaches';
        debugPrint('[ADMIN COACH PROVIDER] ⚠️ API returned error: $_error');
        _coaches = [];
      }
    } catch (e) {
      debugPrint('[ADMIN COACH PROVIDER] ❌ Error fetching coaches: $e');
      _error = 'Terjadi kesalahan: ${e.toString()}';
      _coaches = [];
    }

    _isLoading = false;
    notifyListeners();
    debugPrint('[ADMIN COACH PROVIDER] ✔️ Coaches fetch completed');
  }

  /// Load more coaches (pagination)
  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore || _isLoading) return;

    debugPrint('[ADMIN COACH PROVIDER] 📄 Loading more coaches...');
    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _apiService.getCoaches(
        status: _statusFilter,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        page: nextPage,
        perPage: _perPage,
      );

      if (response['status'] == true) {
        final data = response['data'];
        final coachesList = data['coaches'] as List<dynamic>? ?? [];
        final newCoaches = coachesList.map((json) => Coach.fromJson(json)).toList();
        
        _coaches.addAll(newCoaches);
        _currentPage = nextPage;
        
        if (data['pagination'] != null) {
          _pagination = CoachPagination.fromJson(data['pagination']);
        }
        debugPrint('[ADMIN COACH PROVIDER] ✅ Loaded ${newCoaches.length} more coaches');
      }
    } catch (e) {
      debugPrint('[ADMIN COACH PROVIDER] ❌ Error loading more coaches: $e');
    }

    _isLoadingMore = false;
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
