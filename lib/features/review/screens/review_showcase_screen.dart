import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart';
import 'package:mamicoach_mobile/features/review/models/reviews.dart';
import 'package:mamicoach_mobile/features/review/screens/review_form_screen.dart';
import 'package:mamicoach_mobile/features/review/services/review_service.dart';
import 'package:mamicoach_mobile/features/review/widgets/review_card.dart';
import 'package:mamicoach_mobile/features/review/widgets/review_card_styled.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewShowcaseScreen extends StatefulWidget {
  const ReviewShowcaseScreen({Key? key}) : super(key: key);

  @override
  State<ReviewShowcaseScreen> createState() => _ReviewShowcaseScreenState();
}

class _ReviewShowcaseScreenState extends State<ReviewShowcaseScreen> {
  List<Review> reviews = [];
  bool _isLoading = false;
  String? _error;
  bool _didLoad = false;
  final Map<int, String> _courseTitleById = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoad) return;
    _didLoad = true;
    _loadMyReviews();
  }

  int? _currentUserId(CookieRequest request) {
    final dynamic raw = request.jsonData['user_id'];
    if (raw is int) return raw;
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  Future<void> _loadMyReviews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final request = context.read<CookieRequest>();
    if (!request.loggedIn) {
      setState(() {
        reviews = [];
        _isLoading = false;
        _error = 'You must be logged in to view your reviews.';
      });
      return;
    }

    final result = await ReviewService.listMyReviews(request: request);
    if (!mounted) return;

    if (result['success'] == true) {
      final loadedReviews = (result['reviews'] as List<Review>);
      await _primeCourseTitles(request, loadedReviews);

      if (!mounted) return;
      setState(() {
        reviews = loadedReviews;
        _isLoading = false;
        _error = null;
      });
    } else {
      setState(() {
        reviews = [];
        _isLoading = false;
        _error = result['error']?.toString() ?? 'Failed to fetch reviews';
      });
    }
  }

  Future<void> _primeCourseTitles(CookieRequest request, List<Review> loaded) async {
    final courseIds = loaded.map((r) => r.courseId).toSet();
    final missing = courseIds.where((id) => !_courseTitleById.containsKey(id)).toList();
    if (missing.isEmpty) return;

    // Fetch course titles in parallel (best-effort; failures are ignored).
    await Future.wait(missing.map((courseId) async {
      try {
        final resp = await request.get(
          '${ApiConstants.baseUrl}/api/courses/$courseId/',
        );
        final data = resp is Map<String, dynamic> ? (resp['data'] as Map<String, dynamic>?) : null;
        final title = data?['title']?.toString();
        if (title != null && title.trim().isNotEmpty) {
          _courseTitleById[courseId] = title.trim();
        }
      } catch (_) {
        // ignore
      }
    }));
  }

  bool _isReviewAuthor(Review review) {
    final request = context.read<CookieRequest>();
    final currentUserId = _currentUserId(request);
    if (currentUserId == null || review.userId == null) return false;
    return review.userId == currentUserId;
  }

  Future<void> _handleEditReview(Review review) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewFormScreen(
          review: review,
        ),
      ),
    );

    if (result != null && mounted) {
      await _loadMyReviews();
    }
  }

  Future<void> _handleDeleteReview(Review review) async {
    try {
      // Get CookieRequest from provider
      final request = context.read<CookieRequest>();

      if (!request.loggedIn) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to delete a review'),
            backgroundColor: Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Call API to delete review
      final result = await ReviewService.deleteReview(
        reviewId: review.id,
        request: request,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        await _loadMyReviews();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Review deleted successfully'),
            backgroundColor: const Color(0xFFDC2626),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Failed to delete review'),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting review: $e'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleCreateReview() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReviewFormScreen(
          bookingId: 999,
          courseId: 99,
        ),
      ),
    );

    if (result != null && mounted) {
      await _loadMyReviews();
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    final authorName = request.jsonData['username']?.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Showcase'),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleCreateReview,
        backgroundColor: const Color(0xFF35A753),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Write Review',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading) ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ] else if (_error != null) ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFDC2626)),
                    ),
                  ),
                ),
              ] else if (reviews.isEmpty) ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Text(
                      'No reviews yet.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ] else ...[
              // Standard Review Cards Section
              _buildSectionHeader('Standard Review Cards'),
              const SizedBox(height: 16),
              ...List.generate(
                reviews.length,
                (index) {
                  final review = reviews[index];
                  final isAuthor = _isReviewAuthor(review);
                  final courseTitle = _courseTitleById[review.courseId];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ReviewCard(
                      review: review,
                      isAuthor: isAuthor,
                      authorName: authorName,
                      courseTitle: courseTitle,
                      onEdit: () => _handleEditReview(review),
                      onDelete: () => _handleDeleteReview(review),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              // Styled Review Cards Section
              _buildSectionHeader('Styled Review Cards (Green)'),
              const SizedBox(height: 16),
              ...List.generate(
                reviews.length,
                (index) {
                  final review = reviews[index];
                  final isAuthor = _isReviewAuthor(review);
                  final courseTitle = _courseTitleById[review.courseId];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () =>
                          isAuthor ? _showReviewActionsSheet(context, review) : null,
                      child: ReviewCardStyled(
                        review: review,
                        isAuthor: isAuthor,
                        authorName: authorName,
                        courseTitle: courseTitle,
                      ),
                    ),
                  );
                },
              ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Quicksand',
        color: Color(0xFF1F2937),
      ),
    );
  }

  void _showReviewActionsSheet(BuildContext context, Review review) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Review #${review.id}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _handleEditReview(review);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35A753),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, review);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Review review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFEE2E2),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Color(0xFFDC2626),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Delete Review',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this review? This action cannot be undone.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF4B5563),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF374151),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleDeleteReview(review);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
