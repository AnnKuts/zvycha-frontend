import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'text_field.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    this.label = 'Password',
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: '************',
      controller: controller,
      obscureText: obscure,
      suffixIcon: GestureDetector(
        onTap: onToggle,
        child: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
