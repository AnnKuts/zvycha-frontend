import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: GoogleFonts.comfortaaTextTheme().copyWith(
      titleLarge: GoogleFonts.comfortaa(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      bodyMedium: GoogleFonts.comfortaa(fontSize: 16, color: AppColors.primary),
    ),
  );
}
