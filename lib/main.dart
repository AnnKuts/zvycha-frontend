import 'package:flutter/material.dart';
import 'package:zvycha_frontend/constants/app_text_styles.dart';
import 'package:zvycha_frontend/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomePage(),
      title: 'zvycha',
      theme: AppTheme.lightTheme,
    );
  }
}
