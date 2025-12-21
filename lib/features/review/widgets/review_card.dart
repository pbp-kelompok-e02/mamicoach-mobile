import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/features/review/models/reviews.dart';
import 'package:mamicoach_mobile/core/widgets/proxy_network_image.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final bool isAuthor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? authorAvatarUrl;
  final String? authorName;
  final String? courseTitle;

  const ReviewCard({
    super.key,
    required this.review,
    this.isAuthor = false,
    this.onEdit,
    this.onDelete,
    this.authorAvatarUrl,
    this.authorName,
    this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = review.isAnonymous
        ? 'Pengguna Anonim'
        : (authorName?.trim().isNotEmpty == true
              ? authorName!.trim()
              : 'Pengguna');

    final displayCourseTitle = (courseTitle?.trim().isNotEmpty == true)
        ? courseTitle!.trim()
        : (review.courseId > 0
              ? 'Kelas #${review.courseId}'
              : 'Kelas tidak tersedia');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Name, Role, and Stars
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                    image: (!review.isAnonymous && authorAvatarUrl != null)
                        ? DecorationImage(
                            image: proxyNetworkImageProvider(authorAvatarUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: (review.isAnonymous || authorAvatarUrl == null)
                      ? Icon(
                          Icons.person,
                          size: 28,
                          color: Colors.grey.shade600,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        displayCourseTitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Stars
                Column(
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(
                            index < review.rating
                                ? Icons.star
                                : Icons.star_outline,
                            size: 18,
                            color: index < review.rating
                                ? AppColors.primaryGreen
                                : Colors.grey.shade300,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Review Content
            Text(
              review.content,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF374151),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            // Footer: Date and Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(review.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                if (isAuthor && (onEdit != null || onDelete != null))
                  Row(
                    children: [
                      if (onEdit != null)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onEdit,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 14,
                                    color: const Color(0xFF16A34A),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (onEdit != null && onDelete != null)
                        const SizedBox(width: 8),
                      if (onDelete != null)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _showDeleteDialog(context);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete,
                                    size: 14,
                                    color: Color(0xFFDC2626),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.isNegative) {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes <= 0) return 'Baru saja';
        return '${difference.inMinutes} menit yang lalu';
      }
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu yang lalu';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                  color: AppColors.error,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Delete Review',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this review? This action cannot be undone and will permanently remove your review from the system.',
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
                onDelete?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Delete Review',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
