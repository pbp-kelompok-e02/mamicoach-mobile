import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';
import 'package:mamicoach_mobile/models/course.dart';
import 'package:mamicoach_mobile/screens/course_detail_page.dart';
import 'package:mamicoach_mobile/screens/course_form_page.dart';
import 'package:mamicoach_mobile/screens/schedule_management_page.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart' as api_constants;
import 'package:mamicoach_mobile/core/widgets/proxy_network_image.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  int _currentPage = 1;

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
      print('Error fetching my courses: $e');
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
            setState(() {
              _currentPage = 1; // Refresh list
            });
          },
          backgroundColor: AppColors.primaryGreen,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: FutureBuilder(
          future: fetchMyCourses(request),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              );
            }

            if (!snapshot.hasData || snapshot.data['courses'].isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 64,
                      color: AppColors.darkGrey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Anda belum membuat kelas apapun.',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CourseFormPage(),
                          ),
                        );
                        setState(() {
                          _currentPage = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                      ),
                      child: const Text(
                        'Buat Kelas',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            List<Course> courses = snapshot.data['courses'];
            var pagination = snapshot.data['pagination'];

            return Column(
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
                            builder: (context) => const ScheduleManagementPage(),
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
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      return _buildCourseCard(courses[index]);
                    },
                  ),
                ),

                // Pagination
                if (pagination != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: pagination['has_previous']
                              ? () {
                                  setState(() {
                                    _currentPage--;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.chevron_left),
                          label: const Text(
                            'Sebelumnya',
                            style: TextStyle(fontFamily: 'Quicksand'),
                          ),
                        ),
                        Text(
                          'Halaman ${pagination['current_page']} dari ${pagination['total_pages']}',
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: pagination['has_next']
                              ? () {
                                  setState(() {
                                    _currentPage++;
                                  });
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
            );
          },
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
          );
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
