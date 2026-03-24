import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:zvycha_frontend/core/navigation/route_names.dart';
import '../theme/app_colors.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;

  const CustomHeader({
    super.key,
    required this.title,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap:
              onBackTap ??
              () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppPages.welcome.path);
                }
              },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 28,
            color: AppColors.primary,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.comfortaa(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 32),
      ],
    );
  }
}
