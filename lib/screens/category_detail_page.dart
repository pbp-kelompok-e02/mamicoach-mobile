import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';
import 'package:mamicoach_mobile/models/category_model.dart';
import 'package:mamicoach_mobile/models/course.dart';
import 'package:mamicoach_mobile/models/coach.dart';
import 'package:mamicoach_mobile/screens/course_detail_page.dart';
import 'package:mamicoach_mobile/screens/coach_detail_page.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart'
    as api_constants;
import 'package:mamicoach_mobile/core/widgets/proxy_network_image.dart';
import 'package:mamicoach_mobile/widgets/sequence_loader.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CategoryDetailPage extends StatefulWidget {
  final CategoryModel category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Course>> fetchCoursesByCategory(CookieRequest request) async {
    final response = await request.get(
      '${api_constants.baseUrl}/api/courses/?category=${Uri.encodeComponent(widget.category.name.toLowerCase())}',
    );

    if (response['success'] == true) {
      List<Course> courses = [];
      for (var d in response['data']) {
        courses.add(Course.fromJson(d));
      }
      return courses;
    }
    return [];
  }

  Future<List<Coach>> fetchCoachesByCategory(CookieRequest request) async {
    final response = await request.get(
      '${api_constants.baseUrl}/api/coaches/?expertise=${Uri.encodeComponent(widget.category.name.toLowerCase())}',
    );

    if (response['success'] == true) {
      List<Coach> coaches = [];
      for (var d in response['data']) {
        coaches.add(Coach.fromJson(d));
      }
      return coaches;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return MainLayout(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryGreen, AppColors.darkGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    if (widget.category.thumbnailUrl != null)
                      Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: ProxyNetworkImage(
                            widget.category.thumbnailUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context) => Container(
                              color: Colors.white.withOpacity(0.2),
                              child: Icon(
                                Icons.category,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, error) => Container(
                              color: Colors.white.withOpacity(0.2),
                              child: Icon(
                                Icons.category,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Text(
                      widget.category.name,
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.category.description != null)
                      Text(
                        widget.category.description!,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 16),
                    Text(
                      '${widget.category.courseCount} Kelas Tersedia',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primaryGreen,
                  unselectedLabelColor: AppColors.darkGrey,
                  indicatorColor: AppColors.primaryGreen,
                  labelStyle: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  tabs: const [
                    Tab(text: 'Kelas'),
                    Tab(text: 'Coach'),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Courses Tab
            FutureBuilder<List<Course>>(
              future: fetchCoursesByCategory(request),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 3,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: ShimmerPlaceholder(width: double.infinity, height: 200),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                          'Belum ada kelas untuk kategori ini',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 16,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _buildCourseCard(snapshot.data![index]);
                  },
                );
              },
            ),

            // Coaches Tab
            FutureBuilder<List<Coach>>(
              future: fetchCoachesByCategory(request),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 3,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: ShimmerPlaceholder(width: double.infinity, height: 200),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
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
                          'Belum ada coach untuk kategori ini',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 16,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _buildCoachCard(snapshot.data![index]);
                  },
                );
              },
            ),
          ],
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
          ).then((_) => setState(() {}));
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
                  const SizedBox(height: 8),

                  // Coach
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: AppColors.darkGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          course.coach.fullName,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            color: AppColors.darkGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (course.coach.verified)
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: AppColors.primaryGreen,
                        ),
                    ],
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
                      Flexible(
                        child: Text(
                          course.durationFormatted,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            color: AppColors.darkGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                ],
              ),
            ),
          ],
        ),
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
        );
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
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
