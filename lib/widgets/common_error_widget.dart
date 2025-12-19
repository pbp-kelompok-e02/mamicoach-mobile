import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';

class CommonErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool isConnectionError;

  const CommonErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.isConnectionError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isConnectionError ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
              size: 80,
              color: AppColors.coralRed.withOpacity(0.8),
            ),
            const SizedBox(height: 24),
            Text(
              isConnectionError ? 'Koneksi Terputus' : 'Terjadi Kesalahan',
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 16,
                color: AppColors.darkGrey.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
