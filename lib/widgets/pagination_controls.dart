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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.lightGrey, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          Expanded(
            child: ElevatedButton(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chevron_left,
                    size: 20,
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
                      fontSize: 12,
                      color: (hasPrevious && !isLoading)
                          ? AppColors.primaryGreen
                          : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Page Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$currentPage / $totalPages',
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          // Next Button
          Expanded(
            child: ElevatedButton(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selanjutnya',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: (hasNext && !isLoading)
                          ? AppColors.primaryGreen
                          : AppColors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: (hasNext && !isLoading)
                        ? AppColors.primaryGreen
                        : AppColors.grey,
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
