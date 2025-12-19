import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/core/widgets/proxy_network_image.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/models/coach_detail.dart';
import 'package:mamicoach_mobile/models/category_model.dart';
import 'package:mamicoach_mobile/screens/category_detail_page.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart' as api_constants;
import 'package:mamicoach_mobile/widgets/sequence_loader.dart';
import 'package:mamicoach_mobile/features/chat/widgets/chat_helper.dart';
import 'package:mamicoach_mobile/features/review/widgets/coach_reviews_section.dart';
import 'package:mamicoach_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CoachDetailPage extends StatefulWidget {
  final int coachId;

  const CoachDetailPage({super.key, required this.coachId});

  @override
  State<CoachDetailPage> createState() => _CoachDetailPageState();
}

class _CoachDetailPageState extends State<CoachDetailPage> {
  Future<CoachDetail> fetchCoachDetail(CookieRequest request) async {
    final response = await request.get(
      '${api_constants.baseUrl}/api/coach/${widget.coachId}/',
    );
    return CoachDetail.fromJson(response['data']);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Coach',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchCoachDetail(request),
        builder: (context, AsyncSnapshot<CoachDetail> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ShimmerPlaceholder(width: double.infinity, height: 300),
                SizedBox(height: 16),
                ShimmerPlaceholder(width: double.infinity, height: 200),
              ],
            );
          }

          if (!snapshot.hasData) {
            return Center(
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
            );
          }

          CoachDetail coach = snapshot.data!;
          final userProvider = context.watch<UserProvider>();
          final isOwner = userProvider.username == coach.username;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with profile
                Container(
                  width: double.infinity,
                  color: AppColors.primaryGreen,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Profile picture
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: ClipOval(
                          child: coach.profileImageUrl != null
                              ? ProxyNetworkImage(
                                  coach.profileImageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context) => Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColors.darkGrey,
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColors.darkGrey,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name and verified badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              coach.fullName,
                              style: const TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (coach.verified) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Expertise chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: coach.expertise
                            .map(
                              (exp) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryDetailPage(
                                        category: CategoryModel(
                                          id: 0,
                                          name: exp,
                                          description: null,
                                          thumbnailUrl: null,
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
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    exp,
                                    style: const TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),

                      if (request.loggedIn && !isOwner) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => ChatHelper.startChatWithCoach(
                              context: context,
                              coachId: coach.id,
                              coachName: coach.fullName,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.chat_bubble_outline),
                            label: const Text(
                              'Chat Coach',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Stats section
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        Icons.star,
                        coach.rating.toStringAsFixed(1),
                        'Rating',
                      ),
                      _buildStatItem(
                        Icons.reviews,
                        coach.ratingCount.toString(),
                        'Ulasan',
                      ),
                      _buildStatItem(
                        Icons.school,
                        coach.totalCourses.toString(),
                        'Kelas',
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Bio section
                if (coach.bio != null && coach.bio!.isNotEmpty) ...[
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
                        const SizedBox(height: 12),
                        Text(
                          coach.bio!,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            color: AppColors.darkGrey,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],

                // Experience
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pengalaman',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            coach.totalHoursCoachedFormatted,
                            style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Courses section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kelas yang Diajarkan',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      coach.courses.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Text(
                                  'Belum ada kelas tersedia',
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: coach.courses.length,
                              itemBuilder: (context, index) {
                                return _buildCourseCard(coach.courses[index]);
                              },
                            ),
                    ],
                  ),
                ),

                const Divider(),

                CoachReviewsSection(
                  coachId: coach.id,
                ),
              ],
            ),
          );
        },
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
            fontFamily: 'Quicksand',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 12,
            color: AppColors.darkGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(CoachCourse course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to course detail
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => CourseDetailPage(courseId: course.id),
          //   ),
          // );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: course.thumbnailUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ProxyNetworkImage(
                          course.thumbnailUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context) => Icon(
                            Icons.school,
                            color: AppColors.darkGrey,
                            size: 32,
                          ),
                          errorWidget: (context, error) => Icon(
                            Icons.school,
                            color: AppColors.darkGrey,
                            size: 32,
                          ),
                        ),
                      )
                    : Icon(Icons.school, color: AppColors.darkGrey, size: 32),
              ),
              const SizedBox(width: 12),

              // Course info
              Expanded(
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
                    const SizedBox(height: 4),
                    Text(
                      course.category.name,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          course.priceFormatted,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
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
      ),
    );
  }
}
