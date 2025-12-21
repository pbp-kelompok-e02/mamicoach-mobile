import 'package:flutter/material.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/screens/classes_page.dart';
import 'package:mamicoach_mobile/screens/home_page.dart';

class ServerError500Page extends StatelessWidget {
  const ServerError500Page({super.key});

  static const String routeName = '/500';

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ServerError500Page(),
    );
  }

  void _goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  void _browseClasses(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ClassesPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF2F2), // Tailwind red-50 to match web
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            final imageSize = isWide ? 384.0 : 256.0;

            final image = Image.asset(
              'assets/images/500.png',
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            );

            final content = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Text(
                  'Kesalahan Server',
                  textAlign: isWide ? TextAlign.left : TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: isWide ? 40 : 32,
                        color: AppColors.black,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Maaf, terjadi kesalahan pada server kami. Silakan coba lagi nanti.',
                  textAlign: isWide ? TextAlign.left : TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.grey,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _goHome(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
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
                    ElevatedButton(
                      onPressed: () => _browseClasses(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightGrey,
                        foregroundColor: AppColors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Jelajahi Kelas',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: isWide
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: content),
                            const SizedBox(width: 32),
                            image,
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            image,
                            const SizedBox(height: 24),
                            content,
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
