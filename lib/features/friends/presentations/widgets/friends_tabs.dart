import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zvycha_frontend/core/theme/app_colors.dart';

class FriendsTab extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const FriendsTab({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.25),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Yours',
              isActive: navigationShell.currentIndex == 0,
              onTap: () => navigationShell.goBranch(0),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Find',
              isActive: navigationShell.currentIndex == 1,
              onTap: () => navigationShell.goBranch(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
