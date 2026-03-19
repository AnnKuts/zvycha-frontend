import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFilled;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFilled = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isFilled
        ? ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentGreen,
            foregroundColor: AppColors.primary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          )
        : OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white, width: 1.6),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );

    final textStyle = GoogleFonts.comfortaa(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    );

    return SizedBox(
      width: 182,
      child: isFilled
          ? ElevatedButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: textStyle.copyWith(color: Colors.white),
                ),
              ),
            ),
    );
  }
}
