import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LabeledSection extends StatelessWidget {
  final String label;
  final Widget child;

  const LabeledSection({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
