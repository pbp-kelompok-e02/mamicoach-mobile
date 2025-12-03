import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';

class SnackBarHelper {
  static void showSuccessSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Quicksand'),
        ),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Quicksand'),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Quicksand'),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Quicksand'),
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
