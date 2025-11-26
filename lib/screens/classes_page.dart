import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Classes',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Text(
            'Classes',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Quicksand',
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover classes to help you grow',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Quicksand',
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
