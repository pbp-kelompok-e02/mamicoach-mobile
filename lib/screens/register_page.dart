import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/screens/login_page.dart';
import 'package:mamicoach_mobile/screens/register_coach_page.dart';
import 'package:mamicoach_mobile/widgets/custom_text_field.dart';
import 'package:mamicoach_mobile/widgets/custom_password_field.dart';
import 'package:mamicoach_mobile/widgets/custom_button.dart';
import 'package:mamicoach_mobile/utils/snackbar_helper.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Daftar Akun Baru',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bergabunglah dengan MamiCoach sebagai User',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Quicksand',
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                // Coach Registration Link
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.verified, color: AppColors.primaryGreen, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Ingin menjadi coach?',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            color: AppColors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterCoachPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Daftar Coach',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Username TextField
                CustomTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  hintText: 'Masukkan username',
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // First Name TextField
                CustomTextField(
                  controller: _firstNameController,
                  labelText: 'Nama Depan',
                  hintText: 'Masukkan nama depan',
                  prefixIcon: Icons.badge,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama depan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Last Name TextField
                CustomTextField(
                  controller: _lastNameController,
                  labelText: 'Nama Belakang',
                  hintText: 'Masukkan nama belakang',
                  prefixIcon: Icons.badge_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama belakang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password TextField
                CustomPasswordField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Masukkan password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 8) {
                      return 'Password minimal 8 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password TextField
                CustomPasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Konfirmasi Password',
                  hintText: 'Masukkan ulang password',
                  prefixIcon: Icons.lock_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }
                    if (value != _passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Register Button
                CustomButton(
                  text: 'Daftar',
                  isLoading: _isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        // Ganti dengan URL backend Anda
                        final response = await request.postJson(
                          "http://127.0.0.1:8000/auth/register-user/",
                          jsonEncode({
                            'username': _usernameController.text,
                            'first_name': _firstNameController.text,
                            'last_name': _lastNameController.text,
                            'password1': _passwordController.text,
                            'password2': _confirmPasswordController.text,
                          }),
                        );

                        setState(() {
                          _isLoading = false;
                        });

                        if (context.mounted) {
                          if (response['status'] == true ||
                              response['status'] == 'success') {
                            SnackBarHelper.showSuccessSnackBar(
                              context,
                              response['message'] ?? 'Registrasi berhasil!',
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          } else {
                            SnackBarHelper.showErrorSnackBar(
                              context,
                              response['message'] ?? 'Registrasi gagal!',
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
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: AppColors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Masuk',
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
