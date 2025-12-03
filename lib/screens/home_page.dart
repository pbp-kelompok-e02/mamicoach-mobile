import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/screens/classes_page.dart';
import 'package:mamicoach_mobile/screens/demo_screen.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';
import 'package:mamicoach_mobile/features/admin/screens/admin_login_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Home',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Welcome section
            Text(
              'Welcome to MamiCoach!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Quicksand',
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your parenting coaching platform',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Quicksand',
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClassesPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Explore Classes',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Quicksand',
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Demo button for chat and reviews
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DemoScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppColors.coralRed, width: 2),
              ),
              icon: Icon(Icons.science, color: AppColors.coralRed),
              label: Text(
                'Feature Demo (Chat & Reviews)',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Quicksand',
                  color: AppColors.coralRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            // Admin access button - small and subtle at the bottom
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminLoginScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.admin_panel_settings,
                  size: 16,
                  color: AppColors.grey,
                ),
                label: Text(
                  'Admin Panel',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Quicksand',
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
