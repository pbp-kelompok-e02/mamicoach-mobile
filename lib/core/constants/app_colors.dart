import 'package:flutter/material.dart';

/// App Color Palette for MamiCoach Admin Panel - Matching Main App
class AppColors {
  // Primary Colors - Using MamiCoach Green
  static const Color primary = Color(0xFF35A753); // MamiCoach Primary Green
  static const Color primaryGreen = primary; // Alias for backward compatibility
  static const Color primaryDark = Color(0xFF4A9B4A); // MamiCoach Dark Green
  static const Color primaryLight = Color(0xFF8FD68F); // MamiCoach Light Green

  // Secondary Colors - Using MamiCoach Coral
  static const Color secondary = Color(0xFFE86F6F); // MamiCoach Coral Red
  static const Color secondaryDark = Color(0xFFD85555); // MamiCoach Dark Coral
  static const Color secondaryLight = Color(0xFFF29C9C); // MamiCoach Light Coral

  // Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text Colors - Using MamiCoach Colors
  static const Color textPrimary = Color(0xFF1A1A1A); // MamiCoach Black
  static const Color textSecondary = Color(0xFF757575); // MamiCoach Grey
  static const Color textTertiary = Color(0xFF424242); // MamiCoach Dark Grey

  // Status Colors - Using MamiCoach Theme
  static const Color success = Color(0xFF6BB86B); // MamiCoach Success
  static const Color warning = Color(0xFFFFA726); // MamiCoach Warning
  static const Color error = Color(0xFFE86F6F); // MamiCoach Error (Coral)
  static const Color info = Color(0xFF42A5F5); // MamiCoach Info

  // Chart Colors - MamiCoach Themed
  static const Color chartGreen = Color(0xFF35A753); // Primary Green
  static const Color chartCoral = Color(0xFFE86F6F); // Coral Red
  static const Color chartLightGreen = Color(0xFF8FD68F); // Light Green
  static const Color chartDarkGreen = Color(0xFF4A9B4A); // Dark Green
  static const Color chartLightCoral = Color(0xFFF29C9C); // Light Coral
  static const Color chartAccent = Color(0xFF6BB86B); // Success Green
  // Additional chart colors for compatibility
  static const Color chartBlue = Color(0xFF42A5F5); // Info Blue
  static const Color chartPurple = Color(0xFF8B5CF6); // Purple accent
  static const Color chartYellow = Color(0xFFFFA726); // Warning Yellow
  static const Color chartPink = Color(0xFFEC4899); // Pink accent
  static const Color chartOrange = Color(0xFFF97316); // Orange accent

  // Gradient Colors - MamiCoach Brand
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF35A753), Color(0xFF4A9B4A)], // Green gradient
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE86F6F), Color(0xFFD85555)], // Coral gradient
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF35A753), Color(0xFF6BB86B)], // Success gradient
  );
}
