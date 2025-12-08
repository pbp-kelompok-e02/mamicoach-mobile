import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/models/course_detail.dart';
import 'package:mamicoach_mobile/models/category_model.dart';
import 'package:mamicoach_mobile/screens/category_detail_page.dart';
import 'package:mamicoach_mobile/screens/course_form_page.dart';
import 'package:mamicoach_mobile/config/environment.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CourseDetailPage extends StatefulWidget {
  final int courseId;

  const CourseDetailPage({super.key, required this.courseId});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  Future<CourseDetail> fetchCourseDetail(CookieRequest request) async {
    final response = await request.get(
      '${Environment.baseUrl}/api/courses/${widget.courseId}/',
    );
    return CourseDetail.fromJson(response['data']);
  }

  Future<void> _deleteCourse(CookieRequest request, String title) async {
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
          '${Environment.baseUrl}/api/courses/${widget.courseId}/delete/',
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
            Navigator.pop(context, true);
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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return FutureBuilder(
      future: fetchCourseDetail(request),
      builder: (context, AsyncSnapshot<CourseDetail> snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                )
              : !snapshot.hasData
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.coralRed,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Data tidak ditemukan',
                        style: TextStyle(fontFamily: 'Quicksand', fontSize: 16),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    // App bar with image
                    SliverAppBar(
                      expandedHeight: 250,
                      pinned: true,
                      backgroundColor: AppColors.primaryGreen,
                      flexibleSpace: FlexibleSpaceBar(
                        background: snapshot.data!.thumbnailUrl != null
                            ? Image.network(
                                snapshot.data!.thumbnailUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.lightGrey,
                                    child: Center(
                                      child: Icon(
                                        Icons.school,
                                        size: 80,
                                        color: AppColors.darkGrey,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: AppColors.lightGrey,
                                child: Center(
                                  child: Icon(
                                    Icons.school,
                                    size: 80,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                              ),
                      ),
                    ),

                    // Content
                    SliverToBoxAdapter(
                      child: _buildCourseContent(snapshot.data!, request),
                    ),
                  ],
                ),
          floatingActionButton: snapshot.hasData
              ? _buildActionButtons(snapshot.data!, request)
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _buildCourseContent(CourseDetail course, CookieRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailPage(
                        category: CategoryModel(
                          id: course.category.id,
                          name: course.category.name,
                          description: course.category.description,
                          thumbnailUrl: course.category.thumbnailUrl,
                          courseCount: 0,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
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
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                course.title,
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Stats row
              Row(
                children: [
                  Icon(Icons.star, size: 20, color: AppColors.primaryGreen),
                  const SizedBox(width: 4),
                  Text(
                    course.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' (${course.ratingCount} ulasan)',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 20, color: AppColors.darkGrey),
                  const SizedBox(width: 4),
                  Text(
                    course.durationFormatted,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Price
              Text(
                course.priceFormatted,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ),

        const Divider(),

        // Coach info
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tentang Coach',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lightGrey,
                    ),
                    child: course.coach.profileImageUrl != null
                        ? ClipOval(
                            child: Image.network(
                              course.coach.profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 30,
                                  color: AppColors.darkGrey,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 30,
                            color: AppColors.darkGrey,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                course.coach.fullName,
                                style: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (course.coach.verified) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.verified,
                                size: 16,
                                color: AppColors.primaryGreen,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.primaryGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${course.coach.rating.toStringAsFixed(1)} • ${course.coach.totalHoursCoachedFormatted}',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 12,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (course.coach.bio != null && course.coach.bio!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  course.coach.bio!,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    color: AppColors.darkGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),

        const Divider(),

        // Description
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Deskripsi Kelas',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                course.description,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  color: AppColors.darkGrey,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: AppColors.darkGrey),
                  const SizedBox(width: 8),
                  Text(
                    course.location,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Related courses
        if (course.relatedCourses.isNotEmpty) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kelas Terkait',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: course.relatedCourses.length,
                    itemBuilder: (context, index) {
                      return _buildRelatedCourseCard(
                        course.relatedCourses[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 80), // Space for floating button
      ],
    );
  }

  Widget _buildActionButtons(CourseDetail course, CookieRequest request) {
    // Check if current user is the coach (you'll need to implement auth check)
    // For now, we'll show both buttons side by side for coaches
    final isOwner = request.loggedIn; // Replace with actual ownership check

    if (isOwner) {
      // Show Edit and Delete buttons for course owner
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: FloatingActionButton.extended(
                heroTag: 'edit',
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CourseFormPage(courseDetail: course),
                    ),
                  );
                  if (result == true && mounted) {
                    setState(() {});
                  }
                },
                backgroundColor: AppColors.primaryGreen,
                label: const Text(
                  'Edit Kelas',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FloatingActionButton.extended(
                heroTag: 'delete',
                onPressed: () => _deleteCourse(request, course.title),
                backgroundColor: AppColors.coralRed,
                label: const Text(
                  'Hapus Kelas',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(Icons.delete),
              ),
            ),
          ],
        ),
      );
    }

    // Show booking button for other users
    return FloatingActionButton.extended(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fitur booking akan segera hadir!')),
        );
      },
      backgroundColor: AppColors.primaryGreen,
      label: const Text(
        'Daftar Kelas',
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      icon: const Icon(Icons.add_shopping_cart),
    );
  }

  Widget _buildRelatedCourseCard(RelatedCourse course) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            Navigator.pushReplacement(
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
                        child: Image.network(
                          course.thumbnailUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.school,
                                color: AppColors.darkGrey,
                                size: 32,
                              ),
                            );
                          },
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 12,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.priceFormatted,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
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
      ),
    );
  }
}
