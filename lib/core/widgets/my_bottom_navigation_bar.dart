import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTap;

  const MyBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTap,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: const Color(0xFFB0B0B0),
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, size: 40),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.email, size: 40),
          label: 'Email',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people, size: 40),
          label: 'Friends',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, size: 40),
          label: 'Settings',
        ),
      ],
    );
  }
}
