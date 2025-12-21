import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/widgets/main_layout.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mamicoach_mobile/providers/user_provider.dart';
import 'package:mamicoach_mobile/screens/login_page.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart'
    as api_constants;
import 'package:mamicoach_mobile/utils/snackbar_helper.dart';
import 'package:mamicoach_mobile/core/notifications/push_notification_service.dart';
import 'package:mamicoach_mobile/screens/profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final enabled =
        await PushNotificationService.instance.areChatPushNotificationsEnabled();
    if (!mounted) return;
    setState(() => _notificationsEnabled = enabled);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final userProvider = context.watch<UserProvider>();
    final isLoggedIn = request.loggedIn;

    return MainLayout(
      title: 'Pengaturan',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            if (isLoggedIn) ...[
              _buildSectionHeader('Akun'),
              _buildSettingsCard([
                _buildSettingsTile(
                  icon: Icons.person_outline,
                  title: 'Profil Saya',
                  subtitle: userProvider.username ?? 'Lihat dan edit profil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfilePage(),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.email_outlined,
                  title: 'Username',
                  subtitle: userProvider.username ?? '-',
                  onTap: null,
                ),
              ]),
            ],

            // Notifications Section
            _buildSectionHeader('Notifikasi'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.notifications_outlined,
                title: 'Notifikasi Push',
                subtitle: 'Notifikasi chat untuk pesan baru',
                value: _notificationsEnabled,
                onChanged: (value) async {
                  setState(() => _notificationsEnabled = value);

                  await PushNotificationService.instance
                      .setChatPushNotificationsEnabled(value);

                  // If user is currently logged in, sync backend token state.
                  if (request.loggedIn == true) {
                    if (value) {
                      await PushNotificationService.instance
                          .registerTokenWithBackend(request);
                    } else {
                      await PushNotificationService.instance
                          .unregisterTokenWithBackend(request);
                    }
                  }
                },
              ),
            ]),

            // About Section
            _buildSectionHeader('Tentang'),
            _buildSettingsCard([
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: 'Versi Aplikasi',
                subtitle: '1.0.0',
                onTap: null,
              ),
              _buildDivider(),
              _buildSettingsTile(
                icon: Icons.description_outlined,
                title: 'Syarat & Ketentuan',
                subtitle: 'Baca syarat penggunaan',
                onTap: () {
                  _showTermsDialog(context);
                },
              ),
              _buildDivider(),
              _buildSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Kebijakan Privasi',
                subtitle: 'Pelajari bagaimana data Anda dilindungi',
                onTap: () {
                  _showPrivacyDialog(context);
                },
              ),
            ]),

            // Danger Zone
            if (isLoggedIn) ...[
              _buildSectionHeader(''),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _handleLogout(context, request),
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          'Keluar',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGrey,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 12,
          color: AppColors.grey,
        ),
      ),
      trailing: onTap != null
          ? Icon(Icons.chevron_right, color: AppColors.grey)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 12,
          color: AppColors.grey,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryGreen,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 70,
      endIndent: 16,
      color: AppColors.lightGrey,
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Ubah Password',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Fitur ubah password akan segera tersedia. Saat ini Anda dapat mengubah password melalui website.',
          style: TextStyle(fontFamily: 'Quicksand'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Syarat & Ketentuan',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Dengan menggunakan aplikasi MamiCoach, Anda setuju untuk:\n\n'
            '1. Menggunakan layanan sesuai dengan hukum yang berlaku\n'
            '2. Tidak menyalahgunakan platform untuk aktivitas ilegal\n'
            '3. Menghormati privasi pengguna lain\n'
            '4. Bertanggung jawab atas aktivitas akun Anda\n\n'
            'MamiCoach berhak untuk menangguhkan akun yang melanggar ketentuan ini.',
            style: TextStyle(fontFamily: 'Quicksand'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'MamiCoach berkomitmen melindungi privasi Anda:\n\n'
            '• Data pribadi Anda dienkripsi dan disimpan dengan aman\n'
            '• Kami tidak menjual data Anda ke pihak ketiga\n'
            '• Anda dapat meminta penghapusan data kapan saja\n'
            '• Cookie digunakan untuk meningkatkan pengalaman pengguna\n\n'
            'Untuk informasi lebih lanjut, hubungi support@mamicoach.com',
            style: TextStyle(fontFamily: 'Quicksand'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Hapus Akun',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus akun? Tindakan ini tidak dapat dibatalkan dan semua data Anda akan dihapus secara permanen.',
          style: TextStyle(fontFamily: 'Quicksand'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              SnackBarHelper.showInfoSnackBar(
                context,
                'Silakan hubungi support@mamicoach.com untuk menghapus akun',
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(
    BuildContext context,
    CookieRequest request,
  ) async {
    try {
      // Best-effort: unregister device token BEFORE session logout, but only
      // if chat notifications are enabled.
      final enabled = await PushNotificationService.instance
          .areChatPushNotificationsEnabled();
      if (enabled) {
        await PushNotificationService.instance.unregisterTokenWithBackend(
          request,
        );
      }

      await request.logout('${api_constants.baseUrl}/auth/logout/');
      if (context.mounted) {
        context.read<UserProvider>().clearUser();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showErrorSnackBar(context, 'Gagal logout: $e');
      }
    }
  }
}
