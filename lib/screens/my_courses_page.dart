import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';
import 'package:mamicoach_mobile/models/course.dart';
import 'package:mamicoach_mobile/screens/course_form_page.dart';
import 'package:mamicoach_mobile/screens/course_detail_page.dart';
import 'package:mamicoach_mobile/config/environment.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  int _currentPage = 1;
  bool _isLoading = false;

  Future<Map<String, dynamic>> fetchMyCourses(CookieRequest request) async {
    setState(() => _isLoading = true);
    try {
      final response = await request.get(
        '${Environment.baseUrl}/api/my-courses/?page=$_currentPage',
      );

      if (response['success'] == true) {
        return {
          'courses': (response['data'] as List)
              .map((json) => Course.fromJson(json))
              .toList(),
          'pagination': response['pagination'],
        };
      }
      return {'courses': [], 'pagination': null};
    } catch (e) {
      debugPrint('Error fetching courses: $e');
      return {'courses': [], 'pagination': null};
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteCourse(
    CookieRequest request,
    int courseId,
    String title,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Hapus Kelas',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus kelas "$title"?\n\nTindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(fontFamily: 'Quicksand'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Quicksand',
                color: AppColors.darkGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coralRed,
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(fontFamily: 'Quicksand'),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final response = await request.post(
          '${Environment.baseUrl}/api/courses/$courseId/delete/',
          {},
        );

        if (mounted) {
          if (response['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  response['message'] ?? 'Kelas berhasil dihapus',
                  style: const TextStyle(fontFamily: 'Quicksand'),
                ),
                backgroundColor: AppColors.primaryGreen,
              ),
            );
            setState(() => _currentPage = 1);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  response['message'] ?? 'Gagal menghapus kelas',
                  style: const TextStyle(fontFamily: 'Quicksand'),
                ),
                backgroundColor: AppColors.coralRed,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Terjadi kesalahan: $e',
                style: const TextStyle(fontFamily: 'Quicksand'),
              ),
              backgroundColor: AppColors.coralRed,
            ),
          );
        }
      }
    }
  }

  Widget _buildCourseCard(Course course, CookieRequest request) {
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Container(
                height: 160,
                width: double.infinity,
                color: AppColors.lightGrey,
                child:
                    course.thumbnailUrl != null &&
                        course.thumbnailUrl!.isNotEmpty
                    ? Image.network(
                        course.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.school,
                            size: 48,
                            color: AppColors.darkGrey,
                          );
                        },
                      )
                    : Icon(Icons.school, size: 48, color: AppColors.darkGrey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14,
                      color: AppColors.darkGrey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: AppColors.primaryGreen),
                      const SizedBox(width: 4),
                      Text(
                        course.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' (${course.ratingCount})',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(width: 12),
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
                          fontSize: 14,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      const Spacer(),
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
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CourseFormPage(course: course),
                              ),
                            );
                            if (result == true && mounted) {
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text(
                            'Edit',
                            style: TextStyle(fontFamily: 'Quicksand'),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryGreen,
                            side: BorderSide(color: AppColors.primaryGreen),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _deleteCourse(request, course.id, course.title),
                          icon: const Icon(Icons.delete, size: 18),
                          label: const Text(
                            'Hapus',
                            style: TextStyle(fontFamily: 'Quicksand'),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.coralRed,
                            side: BorderSide(color: AppColors.coralRed),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return MainLayout(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Kelas Saya',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CourseFormPage(),
                      ),
                    );
                    if (result == true && mounted) {
                      setState(() => _currentPage = 1);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Buat Kelas',
                    style: TextStyle(fontFamily: 'Quicksand'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              key: ValueKey(_currentPage),
              future: fetchMyCourses(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    _isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
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
                          'Belum ada kelas',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mulai buat kelas pertama Anda',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CourseFormPage(),
                              ),
                            );
                            if (result == true && mounted) {
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text(
                            'Buat Kelas',
                            style: TextStyle(fontFamily: 'Quicksand'),
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
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          return _buildCourseCard(courses[index], request);
                        },
                      ),
                    ),
                    if (pagination != null && pagination['total_pages'] > 1)
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
        ],
      ),
    );
  }
}
