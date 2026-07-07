import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF1A0B2E);
  static const Color cardBackground = Color(0xFF2D1B4E);
  static const Color silver = Color(0xFFC0C0C8);
  static const Color purpleBright = Color(0xFF9D4EDD);
  static const Color purpleLight = Color(0xFFC77DFF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8A9C9);
  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFBBF24);
  static const Color danger = Color(0xFFF87171);

  static const Color lightBackground = Color(0xFFF3EEFA);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A0B2E);
  static const Color lightTextSecondary = Color(0xFF6B5B7A);

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [purpleBright, purpleLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient appBarGradient = LinearGradient(
    colors: [Color(0xFF2D1B4E), Color(0xFF1A0B2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF1A0B2E), Color(0xFF3C1E70), Color(0xFF9D4EDD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color scoreColor(int score) {
    if (score < 50) return danger;
    if (score <= 75) return warning;
    return success;
  }
}

extension AppColorsContext on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get bg =>
      isDarkMode ? AppColors.background : AppColors.lightBackground;
  Color get cardBg =>
      isDarkMode ? AppColors.cardBackground : AppColors.lightCardBackground;
  Color get textPrimary =>
      isDarkMode ? AppColors.textPrimary : AppColors.lightTextPrimary;
  Color get textSecondary =>
      isDarkMode ? AppColors.textSecondary : AppColors.lightTextSecondary;
}

