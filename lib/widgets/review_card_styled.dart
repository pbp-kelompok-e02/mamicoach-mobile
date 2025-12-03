import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/models/reviews.dart';
import 'package:mamicoach_mobile/constants/colors.dart';

class ReviewCardStyled extends StatelessWidget {
  final Review review;
  final bool isAuthor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? authorAvatarUrl;

  const ReviewCardStyled({
    super.key,
    required this.review,
    this.isAuthor = false,
    this.onEdit,
    this.onDelete,
    this.authorAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Stack(
        children: [
          // Green background container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF35A753),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          // White card with content
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 12,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quote icon - top right
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.format_quote,
                        size: 32,
                        color: const Color(0xFF35A753),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Header: Avatar and User Info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                            image: authorAvatarUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(authorAvatarUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: authorAvatarUrl == null
                              ? Icon(
                                  Icons.person,
                                  size: 24,
                                  color: Colors.grey.shade600,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.isAnonymous
                                    ? 'Anonymous User'
                                    : 'User',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                  fontFamily: 'Quicksand',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Course ID: ${review.courseId}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Review Content - limited to 3 lines
                    Expanded(
                      child: Text(
                        review.content,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF374151),
                          height: 1.5,
                          fontFamily: 'Quicksand',
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Footer with Stars and Course Info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 48,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF35A753),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Star Rating
                  Row(
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_outline,
                          size: 16,
                          color: index < review.rating
                              ? Colors.yellow.shade400
                              : Colors.white.withOpacity(0.3),
                        ),
                      );
                    }),
                  ),
                  // Course Name and Action Buttons
                  if (isAuthor)
                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onEdit,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onDelete,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: Icon(
                                Icons.delete,
                                size: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Course ID: ${review.courseId}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Quicksand',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
