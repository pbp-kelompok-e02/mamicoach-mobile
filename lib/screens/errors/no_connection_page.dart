import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/screens/home_page.dart';

class NoConnectionPage extends StatelessWidget {
  const NoConnectionPage({super.key});

  static const String routeName = '/no-connection';

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const NoConnectionPage());
  }

  void _goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  void _tryAgain(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ghost image
                Image.asset(
                  'assets/images/ghost.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Oops! Tidak Ada Koneksi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Sepertinya kamu sedang offline.\nPeriksa koneksi internet dan coba lagi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 16,
                    color: AppColors.darkGrey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _tryAgain(context),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text(
                        'Coba Lagi',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => _goHome(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        side: const BorderSide(color: AppColors.primaryGreen),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Kembali ke Beranda',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
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
}
