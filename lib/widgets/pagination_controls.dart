import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool hasPrevious;
  final bool hasNext;
  final bool isLoading;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.hasPrevious,
    required this.hasNext,
    required this.isLoading,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Button
          ElevatedButton(
            onPressed: (hasPrevious && !isLoading) ? onPrevious : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primaryGreen,
              elevation: 0,
              side: BorderSide(
                color: (hasPrevious && !isLoading)
                    ? AppColors.primaryGreen
                    : AppColors.lightGrey,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.chevron_left,
                  color: (hasPrevious && !isLoading)
                      ? AppColors.primaryGreen
                      : AppColors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  'Sebelumnya',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    color: (hasPrevious && !isLoading)
                        ? AppColors.primaryGreen
                        : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Page Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Hal $currentPage / $totalPages',
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          // Next Button
          ElevatedButton(
            onPressed: (hasNext && !isLoading) ? onNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primaryGreen,
              elevation: 0,
              side: BorderSide(
                color: (hasNext && !isLoading)
                    ? AppColors.primaryGreen
                    : AppColors.lightGrey,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Row(
              children: [
                Text(
                  'Selanjutnya',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    color: (hasNext && !isLoading)
                        ? AppColors.primaryGreen
                        : AppColors.grey,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: (hasNext && !isLoading)
                      ? AppColors.primaryGreen
                      : AppColors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
