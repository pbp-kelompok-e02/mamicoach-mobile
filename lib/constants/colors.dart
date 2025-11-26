import 'package:flutter/material.dart';

/// MamiCoach Brand Colors
class AppColors {
  static const Color primaryGreen = Color(0xFF35A753);
  static const Color darkGreen = Color(0xFF4A9B4A);
  static const Color lightGreen = Color(0xFF8FD68F);

  static const Color coralRed = Color(0xFFE86F6F);
  static const Color darkCoral = Color(0xFFD85555);
  static const Color lightCoral = Color(0xFFF29C9C);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF424242);

  static const Color success = Color(0xFF6BB86B);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFE86F6F);
  static const Color info = Color(0xFF42A5F5);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, darkGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [coralRed, darkCoral],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
