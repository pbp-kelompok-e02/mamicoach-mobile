import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';
import 'package:mamicoach_mobile/models/course.dart';
import 'package:mamicoach_mobile/models/category_model.dart';
import 'package:mamicoach_mobile/screens/course_detail_page.dart';
import 'package:mamicoach_mobile/screens/category_detail_page.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart'
    as api_constants;
import 'package:mamicoach_mobile/core/widgets/proxy_network_image.dart';
import 'package:mamicoach_mobile/widgets/sequence_loader.dart';
import 'package:mamicoach_mobile/widgets/common_error_widget.dart';
import 'package:mamicoach_mobile/widgets/common_empty_widget.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ClassesPage extends StatefulWidget {
  final String? categoryFilter;
  final String? searchQuery;

  const ClassesPage({super.key, this.categoryFilter, this.searchQuery});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _selectedCategoryName;
  double? _minPrice;
  double? _maxPrice;
  double? _minRating;
  String _sortBy = '-rating';
  int _currentPage = 1;
  List<CategoryModel> _categories = [];
  List<Course> _courses = [];
  Map<String, dynamic>? _pagination;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;
  bool _isConnectionError = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryName = widget.categoryFilter;
    if (widget.searchQuery != null) {
      _searchController.text = widget.searchQuery!;
    }
    _scrollController.addListener(_onScroll);
    _fetchCategories();
    _loadCourses();
  }

  void _onScroll() {
    if (_isLoadingMore || _isLoading) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreCourses();
    }
  }

  Future<void> _loadMoreCourses() async {
    if (_isLoadingMore || _isLoading) return;
    if (_pagination == null || _pagination!['has_next'] != true) return;

    _isLoadingMore = true;
    setState(() {});

    _currentPage++;
    await _loadCourses(isLoadMore: true);
  }

  Future<void> _loadCourses({
    bool isRefresh = false,
    bool isLoadMore = false,
  }) async {
    if (!isRefresh && !isLoadMore) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    final request = context.read<CookieRequest>();
    String url = '${api_constants.baseUrl}/api/courses/?page=$_currentPage';
    if (_searchController.text.isNotEmpty) {
      url += '&search=${Uri.encodeComponent(_searchController.text)}';
    }
    if (_selectedCategoryName != null) {
      url +=
          '&category=${Uri.encodeComponent(_selectedCategoryName!.toLowerCase())}';
    }
    if (_minPrice != null) {
      url += '&min_price=${_minPrice!.toInt()}';
    }
    if (_maxPrice != null) {
      url += '&max_price=${_maxPrice!.toInt()}';
    }
    if (_minRating != null) {
      url += '&min_rating=$_minRating';
    }
    url += '&sort=$_sortBy';

    try {
      final response = await request.get(url);
      if (response['success'] == true) {
        List<Course> courses = [];
        for (var d in response['data']) {
          courses.add(Course.fromJson(d));
        }
        if (mounted) {
          setState(() {
            if (isLoadMore) {
              // Filter out duplicates by checking existing IDs
              final existingIds = _courses.map((c) => c.id).toSet();
              final newCourses = courses
                  .where((c) => !existingIds.contains(c.id))
                  .toList();
              _courses.addAll(newCourses);
            } else {
              _courses = courses;
            }
            _pagination = response['pagination'];
            _isLoading = false;
            _isLoadingMore = false;
          });
        }
      } else {
        if (mounted)
          setState(() {
            _isLoading = false;
            _isLoadingMore = false;
          });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isConnectionError =
              e.toString().contains('SocketException') ||
              e.toString().contains('Connection closed');
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

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategoryName = widget.categoryFilter;
      _minPrice = null;
      _maxPrice = null;
      _minRating = null;
      _sortBy = '-rating';
      _currentPage = 1;
      _courses = [];
    });
    _loadCourses();
  }

  void _applySearch() {
    setState(() {
      _currentPage = 1;
      _courses = [];
    });
    _loadCourses();
  }

  void _showPriceFilter() {
    final minPriceController = TextEditingController(
      text: _minPrice != null ? _minPrice!.toInt().toString() : '',
    );
    final maxPriceController = TextEditingController(
      text: _maxPrice != null ? _maxPrice!.toInt().toString() : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Filter Harga',
          style: TextStyle(fontFamily: 'Quicksand'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: minPriceController,
              decoration: const InputDecoration(
                labelText: 'Harga Minimum',
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: maxPriceController,
              decoration: const InputDecoration(
                labelText: 'Harga Maksimum',
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _minPrice = null;
                _maxPrice = null;
                _currentPage = 1;
                _courses = [];
              });
              Navigator.pop(context);
              _loadCourses();
            },
            child: const Text('Hapus'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _minPrice = double.tryParse(minPriceController.text);
                _maxPrice = double.tryParse(maxPriceController.text);
                _currentPage = 1;
                _courses = [];
              });
              Navigator.pop(context);
              _loadCourses();
            },
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _currentPage = 1;
                  _courses = [];
                });
                await _loadCourses();
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        children: [
                          // Title
                          const Text(
                            'Cari Kelas',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Categories Section
                          if (_categories.isNotEmpty) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Kategori',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _categories.length,
                                itemBuilder: (context, index) {
                                  final category = _categories[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CategoryDetailPage(
                                                category: category,
                                              ),
                                        ),
                                      ).then((_) => setState(() {}));
                                    },
                                    child: Container(
                                      width: 100,
                                      margin: EdgeInsets.only(
                                        right: index < _categories.length - 1
                                            ? 12
                                            : 0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Category Image
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Container(
                                              height: 70,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: AppColors.lightGrey,
                                              ),
                                              child:
                                                  (category
                                                          .thumbnailUrl
                                                          ?.isNotEmpty ??
                                                      false)
                                                  ? ProxyNetworkImage(
                                                      category.thumbnailUrl!,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context) =>
                                                          Icon(
                                                            Icons.category,
                                                            color: AppColors
                                                                .primaryGreen,
                                                            size: 32,
                                                          ),
                                                      errorWidget:
                                                          (
                                                            context,
                                                            error,
                                                          ) => Icon(
                                                            Icons.category,
                                                            color: AppColors
                                                                .primaryGreen,
                                                            size: 32,
                                                          ),
                                                    )
                                                  : Icon(
                                                      Icons.category,
                                                      color: AppColors
                                                          .primaryGreen,
                                                      size: 32,
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          // Category Name
                                          Text(
                                            category.name,
                                            style: const TextStyle(
                                              fontFamily: 'Quicksand',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // Course Count
                                          if (category.courseCount > 0)
                                            Text(
                                              '${category.courseCount} kelas',
                                              style: TextStyle(
                                                fontFamily: 'Quicksand',
                                                fontSize: 12,
                                                color: AppColors.darkGrey,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Search bar
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Cari kelas...',
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
                                          _courses = [];
                                        });
                                        _loadCourses();
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.lightGrey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.lightGrey,
                                ),
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
                                // Clear filters (Moved to start)
                                if (_selectedCategoryName != null ||
                                    _minPrice != null ||
                                    _maxPrice != null ||
                                    _minRating != null ||
                                    _searchController.text.isNotEmpty) ...[
                                  TextButton.icon(
                                    onPressed: _resetFilters,
                                    icon: const Icon(Icons.clear_all),
                                    label: const Text(
                                      'Hapus Filter',
                                      style: TextStyle(fontFamily: 'Quicksand'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],

                                // Category filter
                                PopupMenuButton<String?>(
                                  child: Chip(
                                    label: Text(
                                      _selectedCategoryName ?? 'Kategori',
                                      style: const TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    avatar: const Icon(
                                      Icons.category,
                                      size: 18,
                                    ),
                                    backgroundColor:
                                        _selectedCategoryName != null
                                        ? AppColors.primaryGreen.withOpacity(
                                            0.2,
                                          )
                                        : AppColors.lightGrey,
                                  ),
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedCategoryName =
                                          (value == null || value.isEmpty)
                                          ? null
                                          : value;
                                      _currentPage = 1;
                                      _courses = [];
                                    });
                                    _loadCourses();
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem<String>(
                                      value: '',
                                      child: Text('Semua Kategori'),
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

                                // Price filter
                                ActionChip(
                                  label: Text(
                                    _minPrice != null || _maxPrice != null
                                        ? 'Harga'
                                        : 'Filter Harga',
                                    style: const TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  avatar: const Icon(
                                    Icons.attach_money,
                                    size: 18,
                                  ),
                                  backgroundColor:
                                      _minPrice != null || _maxPrice != null
                                      ? AppColors.primaryGreen.withOpacity(0.2)
                                      : AppColors.lightGrey,
                                  onPressed: _showPriceFilter,
                                ),
                                const SizedBox(width: 8),

                                // Rating filter
                                PopupMenuButton<double>(
                                  child: Chip(
                                    label: Text(
                                      _minRating != null
                                          ? 'Rating ${_minRating!.toStringAsFixed(1)}+'
                                          : 'Rating',
                                      style: const TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    avatar: const Icon(Icons.star, size: 18),
                                    backgroundColor: _minRating != null
                                        ? AppColors.primaryGreen.withOpacity(
                                            0.2,
                                          )
                                        : AppColors.lightGrey,
                                  ),
                                  onSelected: (value) {
                                    setState(() {
                                      _minRating = value == 0.0 ? null : value;
                                      _currentPage = 1;
                                      _courses = [];
                                    });
                                    _loadCourses();
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem<double>(
                                      value: 0.0,
                                      child: Text('Semua Rating'),
                                    ),
                                    PopupMenuItem<double>(
                                      value: 4.5,
                                      child: Text('4.5+ Rating'),
                                    ),
                                    PopupMenuItem<double>(
                                      value: 4.0,
                                      child: Text('4.0+ Rating'),
                                    ),
                                    PopupMenuItem<double>(
                                      value: 3.5,
                                      child: Text('3.5+ Rating'),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),

                                // Sort by
                                PopupMenuButton<String>(
                                  child: Chip(
                                    label: Text(
                                      _sortBy == '-rating'
                                          ? 'Rating Tertinggi'
                                          : _sortBy == 'price'
                                          ? 'Harga Terendah'
                                          : 'Terbaru',
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
                                      _courses = [];
                                    });
                                    _loadCourses();
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: '-rating',
                                      child: Text('Rating Tertinggi'),
                                    ),
                                    PopupMenuItem(
                                      value: 'price',
                                      child: Text('Harga Terendah'),
                                    ),
                                    PopupMenuItem(
                                      value: '-price',
                                      child: Text('Harga Tertinggi'),
                                    ),
                                    PopupMenuItem(
                                      value: '-created_at',
                                      child: Text('Terbaru'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isLoading)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ShimmerPlaceholder(
                            width: double.infinity,
                            height: 200,
                          ),
                        ),
                        childCount: 5,
                      ),
                    )
                  else if (_errorMessage != null)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: CommonErrorWidget(
                        message: _errorMessage!,
                        isConnectionError: _isConnectionError,
                        onRetry: () {
                          _loadCourses();
                        },
                      ),
                    )
                  else if (_courses.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: CommonEmptyWidget(
                        title: 'Tidak ada kelas ditemukan',
                        message:
                            'Coba ubah filter atau kata kunci pencarian Anda',
                        icon: Icons.school_outlined,
                        actionLabel: 'Hapus Filter',
                        onAction: _resetFilters,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 280,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.65,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return _buildCourseCard(_courses[index]);
                        }, childCount: _courses.length),
                      ),
                    ),
                  // Loading More Indicator
                  if (_isLoadingMore)
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                  // End of List Indicator
                  if (!_isLoading &&
                      _courses.isNotEmpty &&
                      _pagination != null &&
                      _pagination!['has_next'] != true)
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'Semua kelas telah ditampilkan',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              color: AppColors.darkGrey,
                              fontSize: 14,
                            ),
                          ),
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

  Widget _buildCourseCard(Course course) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(courseId: course.id),
            ),
          ).then((_) => setState(() {}));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with category overlay
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  course.thumbnailUrl != null
                      ? ProxyNetworkImage(
                          course.thumbnailUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context) => Container(
                            color: AppColors.lightGrey,
                            child: Center(
                              child: Icon(
                                Icons.school,
                                size: 40,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ),
                          errorWidget: (context, error) => Container(
                            color: AppColors.lightGrey,
                            child: Center(
                              child: Icon(
                                Icons.school,
                                size: 40,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.lightGrey,
                          child: Center(
                            child: Icon(
                              Icons.school,
                              size: 40,
                              color: AppColors.darkGrey,
                            ),
                          ),
                        ),
                  // Category badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        course.category.name,
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Price badge
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        course.priceFormatted,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Course info - compact
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Coach
                    Row(
                      children: [
                        Icon(Icons.person, size: 12, color: AppColors.darkGrey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            course.coach.fullName,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 11,
                              color: AppColors.darkGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (course.coach.verified)
                          Icon(
                            Icons.verified,
                            size: 12,
                            color: AppColors.primaryGreen,
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Rating & Duration
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 12,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          course.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' (${course.ratingCount})',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 10,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: AppColors.darkGrey,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            course.durationFormatted,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 11,
                              color: AppColors.darkGrey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
