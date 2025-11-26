import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/screens/classes_page.dart';
import 'package:mamicoach_mobile/screens/home_page.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const MainLayout({super.key, required this.child, this.title = 'MamiCoach'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 70,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40, width: 40),
            const SizedBox(width: 12),
            const Text(
              'mamicoach',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
                fontSize: 24,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari kelas atau coach...',
                    hintStyle: TextStyle(
                      fontFamily: 'Quicksand',
                      color: AppColors.grey,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: AppColors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(context),
      body: child,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.darkGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/logo.png', height: 60, width: 60),
                  const SizedBox(height: 12),
                  const Text(
                    'mamicoach',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quicksand',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Temukan Coach Terbaik Anda',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Quicksand',
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Beranda',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.school,
                  title: 'Cari Kelas',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClassesPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_search,
                  title: 'Cari Coach',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to coaches page
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.verified,
                  title: 'Bergabung Jadi Coach',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to become coach page
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.library_books,
                  title: 'Pembelajaran Saya',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to my learning page
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.login,
                  title: 'Masuk',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to login page
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Navigate to sign up page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Mulai Sekarang',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Pengaturan',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to settings page
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Bantuan & Dukungan',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to help page
                  },
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Quicksand',
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: AppColors.lightGreen.withOpacity(0.1),
    );
  }
}
