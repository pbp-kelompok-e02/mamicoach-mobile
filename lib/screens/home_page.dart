import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/screens/classes_page.dart';
import 'package:mamicoach_mobile/screens/coaches_list_page.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';
import 'package:mamicoach_mobile/features/admin/screens/admin_login_screen.dart';
import 'package:mamicoach_mobile/models/course.dart';
import 'package:mamicoach_mobile/models/coach.dart';
import 'package:mamicoach_mobile/models/category_model.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart'
    as api_constants;
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mamicoach_mobile/core/widgets/proxy_network_image.dart';
import 'package:mamicoach_mobile/screens/course_detail_page.dart';
import 'package:mamicoach_mobile/screens/coach_detail_page.dart';
import 'package:mamicoach_mobile/screens/category_detail_page.dart';
import 'package:mamicoach_mobile/widgets/sequence_loader.dart';
import 'package:mamicoach_mobile/widgets/custom_refresh_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Course> _featuredCourses = [];
  List<Coach> _featuredCoaches = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() => _isRefreshing = true);
    } else {
      setState(() => _isLoading = true);
    }
    final request = context.read<CookieRequest>();
    await Future.wait([
      _fetchFeaturedCourses(request),
      _fetchFeaturedCoaches(request),
      _fetchCategories(request),
    ]);
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _fetchFeaturedCourses(CookieRequest request) async {
    try {
      final response = await request.get(
        '${api_constants.baseUrl}/api/courses/?sort=-rating',
      );
      if (response['success'] == true) {
        List<Course> courses = [];
        for (var d in response['data']) {
          courses.add(Course.fromJson(d));
        }
        if (mounted) {
          setState(() => _featuredCourses = courses.take(5).toList());
        }
      }
    } catch (e) {
      debugPrint('Error fetching featured courses: $e');
    }
  }

  Future<void> _fetchFeaturedCoaches(CookieRequest request) async {
    try {
      final response = await request.get(
        '${api_constants.baseUrl}/api/coaches/?sort=-rating',
      );
      if (response['success'] == true) {
        List<Coach> coaches = [];
        for (var d in response['data']) {
          coaches.add(Coach.fromJson(d));
        }
        if (mounted) {
          setState(() => _featuredCoaches = coaches.take(5).toList());
        }
      }
    } catch (e) {
      debugPrint('Error fetching featured coaches: $e');
    }
  }

  Future<void> _fetchCategories(CookieRequest request) async {
    try {
      final response = await request.get(
        '${api_constants.baseUrl}/api/categories/',
      );
      if (response['success'] == true && response['data'] is List) {
        if (mounted) {
          setState(() {
            _categories = (response['data'] as List)
                .map((json) => CategoryModel.fromJson(json))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'mamicoach',
      child: CustomRefreshIndicator(
        onRefresh: () => _loadAllData(isRefresh: true),
        color: AppColors.primaryGreen,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeroSection(context),
              const SizedBox(height: 24),
              _buildStatsSection(),
              const SizedBox(height: 32),
              _buildCategoriesSection(),
              const SizedBox(height: 32),
              _buildFeaturedCoursesSection(),
              const SizedBox(height: 32),
              _buildFeaturedCoachesSection(),
              const SizedBox(height: 40),
              // Admin access button
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminLoginScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.admin_panel_settings,
                    size: 16,
                    color: AppColors.grey,
                  ),
                  label: const Text(
                    'Admin Panel',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Quicksand',
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Stack(
      children: [
        // Solid green background - fills entire area
        Positioned.fill(child: Container(color: AppColors.primaryGreen)),
        // Background image with fade effect on right side
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/images/register2.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Content
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sports_tennis, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    const Text(
                      'Platform Olahraga #1 Indonesia',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Main title
              const Text(
                'Mulai Hidup\nSehat & Aktif\nBersama Coach\nTerbaik!',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: Colors.white,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                'Akses 100+ kelas olahraga dari coach terverifikasi',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Quicksand',
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari kelas',
                    hintStyle: TextStyle(
                      fontFamily: 'Quicksand',
                      color: AppColors.grey,
                    ),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: AppColors.primaryGreen),
                  ),
                  onSubmitted: (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassesPage(searchQuery: value),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // CTA Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ClassesPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow, size: 20),
                      label: const Text(
                        'Mulai Sekarang',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CoachesListPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_search, size: 20),
                      label: const Text(
                        'Cari Coach',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.star_rounded, '5.0', 'Rating'),
          Container(width: 1, height: 40, color: AppColors.lightGrey),
          _buildStatItem(Icons.people_alt_rounded, '10k+', 'Users'),
          Container(width: 1, height: 40, color: AppColors.lightGrey),
          _buildStatItem(Icons.verified_rounded, '100+', 'Coaches'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Quicksand',
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    if (_categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kategori Populer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: AppColors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClassesPage(),
                    ),
                  );
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          CategoryDetailPage(category: category),
                    ),
                  ).then((_) => _loadAllData());
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background image
                        category.thumbnailUrl != null
                            ? ProxyNetworkImage(
                                category.thumbnailUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context) =>
                                    Container(color: AppColors.primaryGreen),
                                errorWidget: (context, error) =>
                                    Container(color: AppColors.primaryGreen),
                              )
                            : Container(color: AppColors.primaryGreen),
                        // Dark overlay for text readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                category.name,
                                style: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (category.courseCount > 0) ...[
                                const SizedBox(height: 2),
                                Text(
                                  '${category.courseCount} kelas',
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCoursesSection() {
    if (_featuredCourses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelas Populer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Pilihan terbaik dari coach berpengalaman',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Quicksand',
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClassesPage(),
                    ),
                  );
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _featuredCourses.length,
            itemBuilder: (context, index) {
              final course = _featuredCourses[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailPage(courseId: course.id),
                        ),
                      ).then((_) => _loadAllData());
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail with overlays
                        Stack(
                          children: [
                            Container(
                              height: 120,
                              width: double.infinity,
                              color: AppColors.lightGrey,
                              child: course.thumbnailUrl != null
                                  ? ProxyNetworkImage(
                                      course.thumbnailUrl!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context) => Center(
                                        child: Icon(
                                          Icons.school,
                                          color: AppColors.darkGrey,
                                          size: 32,
                                        ),
                                      ),
                                      errorWidget: (context, error) => Center(
                                        child: Icon(
                                          Icons.school,
                                          color: AppColors.darkGrey,
                                          size: 32,
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.school,
                                        color: AppColors.darkGrey,
                                        size: 32,
                                      ),
                                    ),
                            ),
                            // Rating badge
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 12,
                                      color: AppColors.warning,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      course.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category tag
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    course.category.name,
                                    style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  course.title,
                                  style: const TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      course.coach.fullName,
                                      style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontSize: 11,
                                        color: AppColors.darkGrey,
                                      ),
                                    ),
                                    Text(
                                      course.priceFormatted,
                                      style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontSize: 12,
                                        color: AppColors.primaryGreen,
                                        fontWeight: FontWeight.bold,
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCoachesSection() {
    if (_featuredCoaches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Coach Pilihan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: AppColors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CoachesListPage(),
                    ),
                  ).then((_) => _loadAllData());
                },
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _featuredCoaches.length,
            itemBuilder: (context, index) {
              final coach = _featuredCoaches[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CoachDetailPage(coachId: coach.id),
                        ),
                      ).then((_) => _loadAllData());
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.lightGrey,
                            ),
                            child: coach.profileImageUrl != null
                                ? ClipOval(
                                    child: ProxyNetworkImage(
                                      coach.profileImageUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (context) => Icon(
                                        Icons.person,
                                        color: AppColors.darkGrey,
                                      ),
                                      errorWidget: (context, error) => Icon(
                                        Icons.person,
                                        color: AppColors.darkGrey,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 30,
                                    color: AppColors.darkGrey,
                                  ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            coach.fullName,
                            style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            coach.expertise.isNotEmpty
                                ? coach.expertise.first
                                : 'Coach',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                coach.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
