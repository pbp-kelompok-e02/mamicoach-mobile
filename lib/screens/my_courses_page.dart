import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';
import 'package:mamicoach_mobile/models/course.dart';
import 'package:mamicoach_mobile/screens/course_detail_page.dart';
import 'package:mamicoach_mobile/screens/course_form_page.dart';
import 'package:mamicoach_mobile/screens/schedule_management_page.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart' as api_constants;
import 'package:mamicoach_mobile/core/widgets/proxy_network_image.dart';
import 'package:mamicoach_mobile/widgets/sequence_loader.dart';
import 'package:mamicoach_mobile/widgets/custom_refresh_indicator.dart';
import 'package:mamicoach_mobile/widgets/common_error_widget.dart';
import 'package:mamicoach_mobile/widgets/common_empty_widget.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:io';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  int _currentPage = 1;
  List<Course> _courses = [];
  Map<String, dynamic>? _pagination;
  bool _isInitialLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;
  bool _isConnectionError = false;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() => _isRefreshing = true);
    }
    final request = context.read<CookieRequest>();
    String url = '${api_constants.baseUrl}/api/my-courses/?page=$_currentPage';

    try {
      final response = await request.get(url);

      if (response['success'] == true && mounted) {
        List<Course> courses = [];
        for (var d in response['data']) {
          courses.add(Course.fromJson(d));
        }
        setState(() {
          _courses = courses;
          _pagination = response['pagination'];
          _isInitialLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching my courses: $e');
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
          _isRefreshing = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isConnectionError = e.toString().contains('SocketException') || 
                              e.toString().contains('Connection closed');
        });
      }
    }
  }

  Future<Map<String, dynamic>> fetchMyCourses(CookieRequest request) async {
    String url = '${api_constants.baseUrl}/api/my-courses/?page=$_currentPage';

    try {
      final response = await request.get(url);

      if (response['success'] == true) {
        List<Course> courses = [];
        for (var d in response['data']) {
          courses.add(Course.fromJson(d));
        }
        return {'courses': courses, 'pagination': response['pagination']};
      }
    } catch (e) {
      debugPrint('Error fetching my courses: $e');
    }
    return {'courses': [], 'pagination': null};
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return MainLayout(
      title: 'Kelas Saya',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CourseFormPage()),
            );
            _currentPage = 1;
            _loadCourses();
          },
          backgroundColor: AppColors.primaryGreen,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: CustomRefreshIndicator(
          onRefresh: () async {
            _currentPage = 1;
            await _loadCourses(isRefresh: true);
          },
          color: AppColors.primaryGreen,
          child: _isInitialLoading
              ? ListView.builder(
                  itemCount: 3,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: ShimmerPlaceholder(width: double.infinity, height: 200),
                  ),
                )
                  : _errorMessage != null
                      ? CommonErrorWidget(
                          message: _errorMessage!,
                          isConnectionError: _isConnectionError,
                          onRetry: () {
                            setState(() {
                              _isInitialLoading = true;
                              _errorMessage = null;
                            });
                            _loadCourses();
                          },
                        )
                      : _courses.isEmpty
                          ? CommonEmptyWidget(
                              title: 'Anda belum membuat kelas apapun',
                              message: 'Mulai bagikan pengetahuan Anda dengan membuat kelas baru',
                              icon: Icons.school_outlined,
                              actionLabel: 'Buat Kelas',
                              onAction: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CourseFormPage(),
                                  ),
                                );
                                _currentPage = 1;
                                _loadCourses();
                              },
                            )
                          : Stack(
                              children: [
                                Column(
                      children: [
                        // Schedule Management Button
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ScheduleManagementPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.calendar_today),
                              label: const Text(
                                'Atur Ketersediaan Saya',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      return _buildCourseCard(_courses[index]);
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
                                  _loadCourses();
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
                                  _loadCourses();
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
    );
  }

  Widget _buildCourseCard(Course course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(courseId: course.id),
            ),
          ).then((_) => _loadCourses(isRefresh: true));
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 180,
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
                            size: 48,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        errorWidget: (context, error) => Center(
                          child: Icon(
                            Icons.school,
                            size: 48,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.school,
                        size: 48,
                        color: AppColors.darkGrey,
                      ),
                    ),
            ),

            // Course info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      course.category.name,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Rating, Duration, Price
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: AppColors.primaryGreen),
                      const SizedBox(width: 4),
                      Text(
                        course.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.darkGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.durationFormatted,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.priceFormatted,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
