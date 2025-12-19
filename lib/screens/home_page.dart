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
      title: 'MamiCoach',
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryGreen.withOpacity(0.1), Colors.white],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mulai Hidup Aktifmu Sekarang!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Quicksand',
              color: AppColors.black,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Akses 100+ Kelas Olahraga dari Coach Terverifikasi di Seluruh Indonesia',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Quicksand',
              color: AppColors.darkGrey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Temukan gaya olahraga yang cocok buat kamu',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Quicksand',
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 24),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari kelas...',
                hintStyle: TextStyle(
                  fontFamily: 'Quicksand',
                  color: AppColors.grey,
                ),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: AppColors.primaryGreen),
              ),
              onSubmitted: (value) {
                // Navigate to search results or filter classes
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassesPage(searchQuery: value),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClassesPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: AppColors.primaryGreen.withOpacity(0.4),
                  ),
                  child: const Text(
                    'Mulai Sekarang',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClassesPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(
                      color: AppColors.primaryGreen,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Jelajahi Kelas',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.star, '5.0', 'Rating'),
          _buildStatItem(Icons.people, '10k+', 'Users'),
          _buildStatItem(Icons.verified, '100+', 'Coaches'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            color: AppColors.black,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
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
          child: Text(
            'Kategori',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Quicksand',
              color: AppColors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120, // Increased height to prevent overflow
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
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: category.thumbnailUrl != null
                            ? ClipOval(
                                child: ProxyNetworkImage(
                                  category.thumbnailUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (context) => Icon(
                                    Icons.category,
                                    color: AppColors.primaryGreen,
                                  ),
                                  errorWidget: (context, error) => Icon(
                                    Icons.category,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.category,
                                color: AppColors.primaryGreen,
                              ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kelas Olahraga Paling Diminati',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quicksand',
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Temukan kelas-kelas terpopuler dari coach berpengalaman kami',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Quicksand',
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 240,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _featuredCourses.length,
                itemBuilder: (context, index) {
                  final course = _featuredCourses[index];
                  return Container(
                    width: 180,
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
                                  CourseDetailPage(courseId: course.id),
                            ),
                          ).then((_) => _loadAllData());
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: course.thumbnailUrl != null
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: ProxyNetworkImage(
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
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 14,
                                        color: AppColors.warning,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        course.rating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
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
