import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/models/reviews.dart';
import 'package:mamicoach_mobile/widgets/review_card.dart';
import 'package:mamicoach_mobile/widgets/review_card_styled.dart';
import 'package:mamicoach_mobile/screens/review_form_screen.dart';

class ReviewShowcaseScreen extends StatefulWidget {
  const ReviewShowcaseScreen({Key? key}) : super(key: key);

  @override
  State<ReviewShowcaseScreen> createState() => _ReviewShowcaseScreenState();
}

class _ReviewShowcaseScreenState extends State<ReviewShowcaseScreen> {
  late List<Review> reviews;

  @override
  void initState() {
    super.initState();
    _initializeMockReviews();
  }

  void _initializeMockReviews() {
    reviews = [
      Review(
        id: 1,
        rating: 5,
        content:
            'Excellent coaching session! Jane is very professional and understands child psychology well. She provided practical tips that I can implement at home. Highly recommended for parents looking for expert guidance.',
        isAnonymous: false,
        bookingId: 100,
        courseId: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Review(
        id: 2,
        rating: 4,
        content:
            'Great experience overall. The session was informative and the coach was very attentive to my questions. Would have appreciated more personalized exercises, but still very helpful.',
        isAnonymous: true,
        bookingId: 101,
        courseId: 6,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Review(
        id: 3,
        rating: 5,
        content:
            'Amazing! I felt heard and understood throughout the entire session. The coach provided valuable insights and created an action plan that is easy to follow. Looking forward to booking another session.',
        isAnonymous: false,
        bookingId: 102,
        courseId: 7,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Review(
        id: 4,
        rating: 3,
        content:
            'Good session but could be better. The coach was knowledgeable but sometimes lost focus during the discussion. Overall satisfactory.',
        isAnonymous: true,
        bookingId: 103,
        courseId: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
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
      // Update the review in the list
      setState(() {
        final index = reviews.indexWhere((r) => r.id == review.id);
        if (index != -1) {
          reviews[index] = Review(
            id: review.id,
            rating: result['rating'],
            content: result['content'],
            isAnonymous: result['is_anonymous'],
            bookingId: result['booking_id'],
            courseId: result['course_id'],
            createdAt: review.createdAt,
            updatedAt: DateTime.now(),
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review updated successfully'),
          backgroundColor: Color(0xFF35A753),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleDeleteReview(Review review) {
    setState(() {
      reviews.removeWhere((r) => r.id == review.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Review #${review.id} deleted'),
        backgroundColor: const Color(0xFFDC2626),
        duration: const Duration(seconds: 2),
      ),
    );
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
      // Add new review to the list
      setState(() {
        final newReview = Review(
          id: reviews.isEmpty ? 1 : reviews.map((r) => r.id).reduce((a, b) => a > b ? a : b) + 1,
          rating: result['rating'],
          content: result['content'],
          isAnonymous: result['is_anonymous'],
          bookingId: result['booking_id'],
          courseId: result['course_id'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        reviews.insert(0, newReview);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review created successfully'),
          backgroundColor: Color(0xFF35A753),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // Standard Review Cards Section
              _buildSectionHeader('Standard Review Cards'),
              const SizedBox(height: 16),
              ...List.generate(
                reviews.length,
                (index) {
                  final review = reviews[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ReviewCard(
                      review: review,
                      isAuthor: true,
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () => _showReviewActionsSheet(context, review),
                      child: ReviewCardStyled(
                        review: review,
                        isAuthor: true,
                      ),
                    ),
                  );
                },
              ),
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
