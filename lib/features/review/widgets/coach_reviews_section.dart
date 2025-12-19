import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/features/review/models/reviews.dart';
import 'package:mamicoach_mobile/features/review/services/review_service.dart';
import 'package:mamicoach_mobile/features/review/widgets/review_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CoachReviewsSection extends StatefulWidget {
  final int coachId;

  const CoachReviewsSection({
    super.key,
    required this.coachId,
  });

  @override
  State<CoachReviewsSection> createState() => _CoachReviewsSectionState();
}

class _CoachReviewsSectionState extends State<CoachReviewsSection> {
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _reviews = const [];
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
    final result = await ReviewService.listCoachReviews(
      request: request,
      coachId: widget.coachId,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      setState(() {
        _reviews = (result['reviews_raw'] as List<Map<String, dynamic>>);
        _isLoading = false;
        _error = null;
      });
    } else {
      setState(() {
        _reviews = const [];
        _isLoading = false;
        _error = result['error']?.toString() ?? 'Gagal memuat ulasan.';
      });
    }
  }

  int _parseInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    return int.tryParse(v?.toString() ?? '') ?? fallback;
  }

  Map<String, dynamic> _normalizeToReviewJson(Map<String, dynamic> r) {
    final createdAt = r['created_at']?.toString();
    return {
      'id': _parseInt(r['id']),
      'rating': _parseInt(r['rating']),
      'content': r['content']?.toString() ?? '',
      'is_anonymous': r['is_anonymous'] == true,
      // booking_id is required by Review model; use 0 when missing
      'booking_id': _parseInt(r['booking_id'], fallback: 0),
      'course_id': _parseInt(r['course_id']),
      'user_id': r['user_id'] == null ? null : _parseInt(r['user_id']),
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
      'updated_at': r['updated_at']?.toString() ?? createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  String? _authorNameOrNull(Map<String, dynamic> r) {
    final isAnonymous = r['is_anonymous'] == true;
    if (isAnonymous) return null;

    final author = r['author'];
    if (author is Map) {
      final fullName = author['full_name']?.toString().trim();
      if (fullName != null && fullName.isNotEmpty) return fullName;
      final username = author['username']?.toString().trim();
      if (username != null && username.isNotEmpty) return username;
    }

    return null;
  }

  String? _courseTitleOrNull(Map<String, dynamic> r) {
    final c = r['course'];
    if (c is Map) {
      final title = c['title']?.toString().trim();
      if (title != null && title.isNotEmpty) return title;
    }
    return null;
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
                  'Ulasan',
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
                'Belum ada ulasan untuk coach ini.',
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
                final r = _reviews[index];

                final review = Review.fromJson(_normalizeToReviewJson(r));
                return ReviewCard(
                  review: review,
                  authorName: _authorNameOrNull(r),
                  courseTitle: _courseTitleOrNull(r),
                );
              },
            ),
        ],
      ),
    );
  }
}
