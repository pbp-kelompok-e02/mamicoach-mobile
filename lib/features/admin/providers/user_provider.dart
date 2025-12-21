import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/admin_api_service.dart';

/// User Provider for MamiCoach Admin Panel
class UserProvider extends ChangeNotifier {
  final AdminApiService _apiService = AdminApiService();
  
  List<User> _users = [];
  UserPagination? _pagination;
  bool _isLoading = false;
  String? _error;
  
  // Filter state
  String _statusFilter = 'all';
  String _searchQuery = '';
  int _currentPage = 1;
  int _perPage = 10;
  bool _isLoadingMore = false;

  // Getters
  List<User> get users => _users;
  UserPagination? get pagination => _pagination;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get statusFilter => _statusFilter;
  String get searchQuery => _searchQuery;
  bool get hasMore => _pagination?.hasNext ?? false;
  bool get isLoadingMore => _isLoadingMore;

  /// Fetch users with optional filtering
  Future<void> fetchUsers({
    String? status,
    String? search,
    int? page,
    int? perPage,
  }) async {
    debugPrint('[ADMIN USER PROVIDER] 🔄 Starting users fetch...');
    _isLoading = true;
    _error = null;
    
    if (status != null) _statusFilter = status;
    if (search != null) _searchQuery = search;
    if (page != null) _currentPage = page;
    if (perPage != null) _perPage = perPage;
    
    debugPrint('[ADMIN USER PROVIDER] 🔍 Filters - status: $_statusFilter, page: $_currentPage, search: "$_searchQuery"');
    notifyListeners();

    try {
      final response = await _apiService.getUsers(
        status: _statusFilter,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        page: _currentPage,
        perPage: _perPage,
      );

      if (response['status'] == true) {
        final data = response['data'];
        final usersList = data['users'] as List<dynamic>? ?? [];
        _users = usersList.map((json) => User.fromJson(json)).toList();
        
        if (data['pagination'] != null) {
          _pagination = UserPagination.fromJson(data['pagination']);
        }
        debugPrint('[ADMIN USER PROVIDER] ✅ Users fetched successfully: ${_users.length} users');
      } else {
        _error = response['message'] ?? 'Failed to fetch users';
        debugPrint('[ADMIN USER PROVIDER] ⚠️ API returned error: $_error');
        _users = [];
      }
    } catch (e) {
      debugPrint('[ADMIN USER PROVIDER] ❌ Error fetching users: $e');
      _error = 'Terjadi kesalahan: ${e.toString()}';
      _users = [];
    }

    _isLoading = false;
    notifyListeners();
    debugPrint('[ADMIN USER PROVIDER] ✔️ Users fetch completed');
  }

  /// Load more users (pagination)
  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore || _isLoading) return;

    debugPrint('[ADMIN USER PROVIDER] 📄 Loading more users...');
    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await _apiService.getUsers(
        status: _statusFilter,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        page: nextPage,
        perPage: _perPage,
      );

      if (response['status'] == true) {
        final data = response['data'];
        final usersList = data['users'] as List<dynamic>? ?? [];
        final newUsers = usersList.map((json) => User.fromJson(json)).toList();
        
        _users.addAll(newUsers);
        _currentPage = nextPage;
        
        if (data['pagination'] != null) {
          _pagination = UserPagination.fromJson(data['pagination']);
        }
        debugPrint('[ADMIN USER PROVIDER] ✅ Loaded ${newUsers.length} more users');
      }
    } catch (e) {
      debugPrint('[ADMIN USER PROVIDER] ❌ Error loading more users: $e');
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
