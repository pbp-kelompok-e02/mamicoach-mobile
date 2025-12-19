import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/screens/classes_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mamicoach_mobile/screens/home_page.dart';
import 'package:mamicoach_mobile/screens/login_page.dart';
import 'package:mamicoach_mobile/screens/register_page.dart';
import 'package:mamicoach_mobile/screens/coaches_list_page.dart';
import 'package:mamicoach_mobile/screens/my_courses_page.dart';
import 'package:mamicoach_mobile/screens/my_bookings_page.dart';
import 'package:mamicoach_mobile/screens/coach_bookings_page.dart';
import 'package:mamicoach_mobile/providers/user_provider.dart';
import 'package:mamicoach_mobile/features/chat/screens/chat_index_screen.dart';
import 'package:mamicoach_mobile/screens/register_coach_page.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart';
import 'package:mamicoach_mobile/utils/snackbar_helper.dart';
import 'package:mamicoach_mobile/screens/profile_page.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final String title;

  const MainLayout({super.key, required this.child, this.title = 'mamicoach'});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 70,
        titleSpacing: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: _isSearching ? 34 : 38,
              width: _isSearching ? 34 : 38,
            ),
            const SizedBox(width: 8),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: _isSearching
                  ? const SizedBox.shrink()
                  : Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                        fontSize: 20,
                      ),
                    ),
            ),
            SizedBox(width: _isSearching ? 8 : 12),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: !_isSearching
                    ? const SizedBox.shrink()
                    : Container(
                        key: const ValueKey('searchField'),
                        height: 45,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Cari kelas atau coach...',
                            hintStyle: TextStyle(
                              fontFamily: 'Quicksand',
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.grey,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            final query = value.trim();
                            if (query.isEmpty) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ClassesPage(searchQuery: query),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) {
              final request = context.watch<CookieRequest>();
              return Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isSearching ? Icons.close : Icons.search,
                      color: AppColors.black,
                    ),
                    onPressed: _toggleSearch,
                  ),
                  if (!_isSearching) ...[
                    // Connected User Info (Username + Avatar) or Login Icon
                    Builder(
                      builder: (context) {
                        final userProvider = context.watch<UserProvider>();
                        final bool isLoggedIn = userProvider.username != null;

                        if (isLoggedIn) {
                          final profilePic = userProvider.profilePicture;
                          final username =
                              request.jsonData['username'] ??
                              userProvider.username ??
                              'User';

                          Widget profileAvatar;
                          if (profilePic != null && profilePic.isNotEmpty) {
                            String imageUrl = profilePic;
                            if (!imageUrl.startsWith('http')) {
                              imageUrl = "${ApiConstants.baseUrl}$imageUrl";
                            }
                            profileAvatar = CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(imageUrl),
                              backgroundColor: Colors.transparent,
                            );
                          } else {
                            profileAvatar = const CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.lightGrey,
                              child: Icon(Icons.person, color: AppColors.black),
                            );
                          }

                          return PopupMenuButton<String>(
                            offset: const Offset(0, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tooltip: 'Menu Profil',
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 8),
                                  profileAvatar,
                                ],
                              ),
                            ),
                            onSelected: (value) async {
                              if (value == 'profile') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfilePage(),
                                  ),
                                );
                              } else if (value == 'logout') {
                                try {
                                  final response = await request.logout(
                                    "${ApiConstants.baseUrl}/auth/api_logout/",
                                  );

                                  if (context.mounted) {
                                    if (response['status'] == true) {
                                      final userProvider =
                                          Provider.of<UserProvider>(
                                            context,
                                            listen: false,
                                          );
                                      userProvider.clearUser();

                                      SnackBarHelper.showSuccessSnackBar(
                                        context,
                                        response['message'] ??
                                            'Logout berhasil!',
                                      );

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage(),
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
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem<String>(
                                value: 'profile',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.dashboard,
                                      color: AppColors.primaryGreen,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Dashboard',
                                      style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    Icon(Icons.logout, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(
                                      'Keluar',
                                      style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Not Logged In
                          return IconButton(
                            icon: const Icon(
                              Icons.account_circle,
                              color: AppColors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(context),
      body: widget.child,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final bool isLoggedIn = userProvider.username != null;
        return Drawer(
          child: Column(
            children: [
              // Drawer Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
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
                      Image.asset(
                        'assets/images/logo.png',
                        height: 60,
                        width: 60,
                      ),
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
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CoachesListPage(),
                          ),
                        );
                      },
                    ),
                    if (isLoggedIn)
                      _buildDrawerItem(
                        context,
                        icon: Icons.chat_bubble_outline,
                        title: 'Pesan Saya',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatIndexScreen(),
                            ),
                          );
                        },
                      ),
                    const Divider(),

                    // Show "Kelas Saya" only for coaches
                    if (userProvider.isCoach)
                      _buildDrawerItem(
                        context,
                        icon: Icons.school_outlined,
                        title: 'Kelas Saya',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyCoursesPage(),
                            ),
                          );
                        },
                      ),

                    // Show "Booking Masuk" only for coaches
                    if (userProvider.isCoach)
                      _buildDrawerItem(
                        context,
                        icon: Icons.calendar_today,
                        title: 'Booking Masuk',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CoachBookingsPage(),
                            ),
                          );
                        },
                      ),

                    // Show "Pembelajaran Saya" only for regular users (non-coaches) who are logged in
                    if (isLoggedIn && !userProvider.isCoach)
                      _buildDrawerItem(
                        context,
                        icon: Icons.library_books,
                        title: 'Pembelajaran Saya',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyBookingsPage(),
                            ),
                          );
                        },
                      ),

                    if (!isLoggedIn) ...[
                      _buildDrawerItem(
                        context,
                        icon: Icons.verified,
                        title: 'Bergabung Jadi Coach',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterCoachPage(),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      _buildDrawerItem(
                        context,
                        icon: Icons.login,
                        title: 'Masuk',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
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
                    ],
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
      },
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
