import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zvycha_frontend/constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zvycha',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.comfortaaTextTheme(),
      ),
    );
  }
}
