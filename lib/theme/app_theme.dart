import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.purpleBright,
        secondary: AppColors.purpleLight,
        surface: AppColors.cardBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardColor: AppColors.cardBackground,
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.cardBackground,
      ),
      iconTheme: const IconThemeData(color: AppColors.silver),
    );
  }

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: AppColors.lightTextPrimary,
        displayColor: AppColors.lightTextPrimary,
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.purpleBright,
        secondary: AppColors.purpleLight,
        surface: AppColors.lightCardBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardColor: AppColors.lightCardBackground,
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.lightCardBackground,
      ),
      iconTheme: const IconThemeData(color: AppColors.purpleBright),
    );
  }
}
