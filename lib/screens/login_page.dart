import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart';
import 'package:mamicoach_mobile/screens/register_page.dart';
import 'package:mamicoach_mobile/screens/home_page.dart';
import 'package:mamicoach_mobile/widgets/custom_text_field.dart';
import 'package:mamicoach_mobile/widgets/custom_password_field.dart';
import 'package:mamicoach_mobile/widgets/custom_button.dart';
import 'package:mamicoach_mobile/utils/snackbar_helper.dart';
import 'package:mamicoach_mobile/providers/user_provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mamicoach_mobile/core/notifications/push_notification_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/logo.png', height: 100, width: 100),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Masuk ke MamiCoach',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selamat datang kembali!',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Quicksand',
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                // Username TextField
                CustomTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  hintText: 'Masukkan username',
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 16),

                // Password TextField
                CustomPasswordField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Masukkan password',
                ),
                const SizedBox(height: 24),

                // Login Button
                CustomButton(
                  text: 'Masuk',
                  isLoading: _isLoading,
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    String username = _usernameController.text;
                    String password = _passwordController.text;

                    if (username.isEmpty || password.isEmpty) {
                      setState(() {
                        _isLoading = false;
                      });
                      SnackBarHelper.showErrorSnackBar(
                        context,
                        'Username dan password tidak boleh kosong!',
                      );
                      return;
                    }

                    try {
                      final response = await request.login(
                        "${ApiConstants.baseUrl}/auth/api_login/",
                        {'username': username, 'password': password},
                      );

                      setState(() {
                        _isLoading = false;
                      });

                      if (context.mounted) {
                        if (response['status'] == true) {
                          String message = response['message'];

                          // Store username and isCoach in provider
                          final userProvider = Provider.of<UserProvider>(
                            context,
                            listen: false,
                          );
                          userProvider.setUser(
                            response['username'],
                            response['is_coach'] ?? false,
                            profilePicture: response['profile_image'],
                          );

                          // Best-effort: register this device token for push notifications.
                          await PushNotificationService.instance
                              .registerTokenWithBackend(request);

                          SnackBarHelper.showSuccessSnackBar(
                            context,
                            '$message Selamat datang, ${response['username']}!',
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );

                          // If user tapped a notification while logged-out,
                          // try navigating to the target chat after login.
                          PushNotificationService.instance
                              .tryHandlePendingNavigation();
                        } else {
                          SnackBarHelper.showErrorSnackBar(
                            context,
                            response['message'] ?? 'Login gagal!',
                          );
                        }
                      }
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });

                      if (context.mounted) {
                        SnackBarHelper.showErrorSnackBar(
                          context,
                          'Terjadi kesalahan: $e',
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: AppColors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
