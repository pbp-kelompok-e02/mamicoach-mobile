import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/features/review/models/reviews.dart';

class ReviewCardStyled extends StatelessWidget {
  final Review review;
  final bool isAuthor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? authorAvatarUrl;
  final String? authorName;
  final String? courseTitle;
  final VoidCallback? onOpenCourse;

  const ReviewCardStyled({
    super.key,
    required this.review,
    this.isAuthor = false,
    this.onEdit,
    this.onDelete,
    this.authorAvatarUrl,
    this.authorName,
    this.courseTitle,
    this.onOpenCourse,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = review.isAnonymous
        ? 'Anonymous User'
        : (authorName?.trim().isNotEmpty == true ? authorName!.trim() : 'User');
    final displayCourseTitle = (courseTitle?.trim().isNotEmpty == true)
      ? courseTitle!.trim()
      : 'Course #${review.courseId}';

    return SizedBox(
      width: double.infinity,
      height: 240,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF35A753),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // White inner card
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Stack(
                  children: [
                    // Quote icon (top-right)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Icon(
                        Icons.format_quote,
                        size: 32,
                        color: const Color(0xFF35A753),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade300,
                                  image: (!review.isAnonymous && authorAvatarUrl != null)
                                      ? DecorationImage(
                                          image: NetworkImage(authorAvatarUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: (review.isAnonymous || authorAvatarUrl == null)
                                    ? Icon(
                                        Icons.person,
                                        size: 24,
                                        color: Colors.grey.shade600,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF111827),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
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
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Text(
                              review.content,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF374151),
                                height: 1.5,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Footer on green background
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(
                          Icons.star,
                          size: 16,
                          color: index < review.rating
                              ? Colors.yellow.shade400
                              : Colors.white.withOpacity(0.30),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: onOpenCourse,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                displayCourseTitle,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
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
