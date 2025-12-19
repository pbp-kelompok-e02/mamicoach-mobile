import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mamicoach_mobile/screens/user_profile_edit_page.dart';
import 'package:mamicoach_mobile/screens/coach_profile_edit_page.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';

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

    // Langsung tampilkan halaman edit profil sesuai tipe user
    return userProvider.isCoach
        ? const CoachProfileEditPage()
        : const UserProfileEditPage();
  }
}
