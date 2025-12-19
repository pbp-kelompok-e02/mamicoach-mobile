import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/core/widgets/proxy_network_image.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/models/coach.dart';
import 'package:mamicoach_mobile/models/category_model.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';
import 'package:mamicoach_mobile/screens/coach_detail_page.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart' as api_constants;
import 'package:mamicoach_mobile/widgets/sequence_loader.dart';
import 'package:mamicoach_mobile/widgets/custom_refresh_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CoachesListPage extends StatefulWidget {
  const CoachesListPage({super.key});

  @override
  State<CoachesListPage> createState() => _CoachesListPageState();
}

class _CoachesListPageState extends State<CoachesListPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedExpertiseName;
  bool? _verifiedOnly;
  String _sortBy = '-rating';
  int _currentPage = 1;
  List<CategoryModel> _categories = [];
  List<Coach> _coaches = [];
  Map<String, dynamic>? _pagination;
  bool _isInitialLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _loadCoaches();
  }

  Future<void> _loadCoaches({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() => _isRefreshing = true);
    }
    final request = context.read<CookieRequest>();
    try {
      final data = await fetchCoaches(request);
      if (mounted) {
        setState(() {
          _coaches = data['coaches'];
          _pagination = data['pagination'];
          _isInitialLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _fetchCategories() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
        '${api_constants.baseUrl}/api/categories/',
      );
      if (response['success'] == true && response['data'] is List) {
        setState(() {
          _categories = (response['data'] as List)
              .map((json) => CategoryModel.fromJson(json))
              .toList();
        });
      }
    } catch (e) {
      // Categories failed to load, continue without them
    }
  }

  Future<Map<String, dynamic>> fetchCoaches(CookieRequest request) async {
    // Build query parameters
    String url = '${api_constants.baseUrl}/api/coaches/?page=$_currentPage';

    if (_searchController.text.isNotEmpty) {
      url += '&search=${Uri.encodeComponent(_searchController.text)}';
    }
    if (_selectedExpertiseName != null) {
      url +=
          '&expertise=${Uri.encodeComponent(_selectedExpertiseName!.toLowerCase())}';
    }
    if (_verifiedOnly == true) {
      url += '&verified=true';
    }
    url += '&sort=$_sortBy';

    final response = await request.get(url);

    if (response['success'] == true) {
      List<Coach> coaches = [];
      for (var d in response['data']) {
        coaches.add(Coach.fromJson(d));
      }
      return {'coaches': coaches, 'pagination': response['pagination']};
    }
    return {'coaches': [], 'pagination': null};
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedExpertiseName = null;
      _verifiedOnly = null;
      _sortBy = '-rating';
      _currentPage = 1;
    });
    _loadCoaches();
  }

  void _applySearch() {
    setState(() {
      _currentPage = 1;
    });
    _loadCoaches();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return MainLayout(
      child: Column(
        children: [
          // Search and filter section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Title
                const Text(
                  'Cari Coach',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari coach...',
                    hintStyle: TextStyle(
                      fontFamily: 'Quicksand',
                      color: AppColors.darkGrey,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.primaryGreen,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _currentPage = 1;
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.lightGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.lightGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primaryGreen,
                        width: 2,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _applySearch(),
                ),
                const SizedBox(height: 12),

                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Expertise filter
                      PopupMenuButton<String?>(
                        child: Chip(
                          label: Text(
                            _selectedExpertiseName ?? 'Keahlian',
                            style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          avatar: const Icon(Icons.filter_list, size: 18),
                          backgroundColor: _selectedExpertiseName != null
                              ? AppColors.primaryGreen.withOpacity(0.2)
                              : AppColors.lightGrey,
                        ),
                        onSelected: (value) {
                          setState(() {
                            _selectedExpertiseName = value;
                            _currentPage = 1;
                          });
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: null,
                            child: Text('Semua Keahlian'),
                          ),
                          ..._categories.map(
                            (category) => PopupMenuItem(
                              value: category.name,
                              child: Text(category.name),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),

                      // Verified filter
                      FilterChip(
                        label: const Text(
                          'Terverifikasi',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        selected: _verifiedOnly ?? false,
                        onSelected: (selected) {
                          setState(() {
                            _verifiedOnly = selected ? true : null;
                            _currentPage = 1;
                          });
                        },
                        selectedColor: AppColors.primaryGreen.withOpacity(0.2),
                        checkmarkColor: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 8),

                      // Sort by
                      PopupMenuButton<String>(
                        child: Chip(
                          label: Text(
                            _sortBy == '-rating'
                                ? 'Rating Tertinggi'
                                : 'Nama A-Z',
                            style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          avatar: const Icon(Icons.sort, size: 18),
                          backgroundColor: AppColors.lightGrey,
                        ),
                        onSelected: (value) {
                          setState(() {
                            _sortBy = value;
                            _currentPage = 1;
                          });
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: '-rating',
                            child: Text('Rating Tertinggi'),
                          ),
                          PopupMenuItem(
                            value: '-total_minutes_coached',
                            child: Text('Pengalaman Terbanyak'),
                          ),
                          PopupMenuItem(
                            value: 'username',
                            child: Text('Nama A-Z'),
                          ),
                        ],
                      ),

                      // Clear filters
                      if (_selectedExpertiseName != null ||
                          _verifiedOnly != null ||
                          _searchController.text.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: _resetFilters,
                          icon: const Icon(Icons.clear_all),
                          label: const Text(
                            'Hapus Filter',
                            style: TextStyle(fontFamily: 'Quicksand'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: CustomRefreshIndicator(
              onRefresh: () async {
                _currentPage = 1;
                await _loadCoaches(isRefresh: true);
              },
              color: AppColors.primaryGreen,
              child: _isInitialLoading
                  ? ListView.builder(
                      itemCount: 5,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: ShimmerPlaceholder(width: double.infinity, height: 200),
                      ),
                    )
                  : _coaches.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_search,
                                      size: 64,
                                      color: AppColors.darkGrey,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Tidak ada coach ditemukan',
                                      style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontSize: 16,
                                        color: AppColors.darkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            Column(
                          children: [
                            Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: _coaches.length,
                                itemBuilder: (context, index) {
                                  return _buildCoachCard(_coaches[index]);
                                },
                              ),
                            ),

                            // Pagination
                            if (_pagination != null)
                              Container(
                                padding: const EdgeInsets.all(16),
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                              onPressed: _pagination!['has_previous']
                                  ? () {
                                      setState(() {
                                        _currentPage--;
                                      });
                                      _loadCoaches();
                                    }
                                  : null,
                              icon: const Icon(Icons.chevron_left),
                              label: const Text(
                                'Sebelumnya',
                                style: TextStyle(fontFamily: 'Quicksand'),
                              ),
                            ),
                            Text(
                              'Halaman ${_pagination!['current_page']} dari ${_pagination!['total_pages']}',
                              style: const TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _pagination!['has_next']
                                  ? () {
                                      setState(() {
                                        _currentPage++;
                                      });
                                      _loadCoaches();
                                    }
                                  : null,
                              icon: const Icon(Icons.chevron_right),
                              label: const Text(
                                'Selanjutnya',
                                style: TextStyle(fontFamily: 'Quicksand'),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                            if (_isRefreshing)
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.primaryGreen,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Memperbarui data...',
                                        style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontSize: 14,
                                          color: AppColors.darkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachCard(Coach coach) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoachDetailPage(coachId: coach.id),
          ),
        ).then((_) => setState(() {}));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: coach.profileImageUrl != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: ProxyNetworkImage(
                            coach.profileImageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context) => Center(
                              child: Icon(
                                Icons.person,
                                size: 48,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            errorWidget: (context, error) => Center(
                              child: Icon(
                                Icons.person,
                                size: 48,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.person,
                            size: 48,
                            color: AppColors.darkGrey,
                          ),
                        ),
                ),
                if (coach.verified)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),

            // Coach info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coach.fullName,
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coach.expertise.isNotEmpty ? coach.expertise.first : '',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        color: AppColors.darkGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          coach.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' (${coach.ratingCount})',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 11,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coach.totalHoursCoachedFormatted,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 11,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
