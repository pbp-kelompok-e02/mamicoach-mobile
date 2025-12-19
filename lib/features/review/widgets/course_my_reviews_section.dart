import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/features/review/models/reviews.dart';
import 'package:mamicoach_mobile/features/review/services/review_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CourseMyReviewsSection extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const CourseMyReviewsSection({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<CourseMyReviewsSection> createState() => _CourseMyReviewsSectionState();
}

class _CourseMyReviewsSectionState extends State<CourseMyReviewsSection> {
  bool _isLoading = false;
  String? _error;
  List<Review> _reviews = [];
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoad) return;
    _didLoad = true;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final request = context.read<CookieRequest>();
    if (!request.loggedIn) {
      setState(() {
        _reviews = [];
        _isLoading = false;
        _error = 'Silakan login untuk melihat ulasan Anda.';
      });
      return;
    }

    final result = await ReviewService.listMyReviews(
      request: request,
      courseId: widget.courseId,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      setState(() {
        _reviews = (result['reviews'] as List<Review>);
        _isLoading = false;
        _error = null;
      });
    } else {
      setState(() {
        _reviews = [];
        _isLoading = false;
        _error = result['error']?.toString() ?? 'Gagal memuat ulasan.';
      });
    }
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Ulasan Anda',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: _isLoading ? null : _load,
                icon: const Icon(Icons.refresh, color: AppColors.darkGrey),
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.courseTitle,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 13,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                ),
              ),
            )
          else if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    color: AppColors.coralRed,
                  ),
                ),
              ),
            )
          else if (_reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Belum ada ulasan dari Anda untuk kelas ini.',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: AppColors.darkGrey,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reviews.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.lightGrey.withOpacity(0.7)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (i) {
                                final isFilled = i < review.rating;
                                return Icon(
                                  isFilled ? Icons.star : Icons.star_border,
                                  size: 18,
                                  color: isFilled ? AppColors.primaryGreen : AppColors.lightGrey,
                                );
                              }),
                            ),
                            const Spacer(),
                            Text(
                              _formatDate(review.createdAt),
                              style: const TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          review.content,
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            color: AppColors.black,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
