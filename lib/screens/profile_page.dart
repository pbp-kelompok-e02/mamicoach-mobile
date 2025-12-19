import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/providers/user_provider.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart';
import 'package:mamicoach_mobile/screens/home_page.dart';
import 'package:mamicoach_mobile/utils/snackbar_helper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access user provider securely
    final userProvider = context.watch<UserProvider>();
    final request = context.read<CookieRequest>();

    // If for some reason not logged in
    if (!request.loggedIn) {
      return const MainLayout(
        title: 'Profil',
        child: Center(child: Text("Silakan login terlebih dahulu.")),
      );
    }

    String? profilePic = userProvider.profilePicture;
    if (profilePic != null &&
        profilePic.isNotEmpty &&
        !profilePic.startsWith('http')) {
      profilePic = "${ApiConstants.baseUrl}$profilePic";
    }

    return MainLayout(
      title: 'Profil Saya',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryGreen, width: 4),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: profilePic != null && profilePic.isNotEmpty
                    ? Image.network(
                        profilePic,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.grey,
                            ),
                      )
                    : const Icon(Icons.person, size: 60, color: AppColors.grey),
              ),
            ),
            const SizedBox(height: 24),

            // Name
            Text(
              userProvider.username ?? 'User',
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),

            // User Type Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: userProvider.isCoach
                    ? AppColors.primaryGreen.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: userProvider.isCoach
                      ? AppColors.primaryGreen
                      : Colors.blue,
                ),
              ),
              child: Text(
                userProvider.isCoach ? 'Coach' : 'User',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  color: userProvider.isCoach
                      ? AppColors.primaryGreen
                      : Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Logout Button (Redundant but good to have)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final response = await request.logout(
                      "${ApiConstants.baseUrl}/auth/api_logout/",
                    );

                    if (context.mounted) {
                      if (response['status'] == true) {
                        final userProvider = Provider.of<UserProvider>(
                          context,
                          listen: false,
                        );
                        userProvider.clearUser();

                        SnackBarHelper.showSuccessSnackBar(
                          context,
                          response['message'] ?? 'Logout berhasil!',
                        );

                        // Navigate to home or refresh
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false,
                        );
                      } else {
                        SnackBarHelper.showErrorSnackBar(
                          context,
                          response['message'] ?? 'Logout gagal!',
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      SnackBarHelper.showErrorSnackBar(
                        context,
                        'Terjadi kesalahan saat logout: $e',
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Keluar',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
