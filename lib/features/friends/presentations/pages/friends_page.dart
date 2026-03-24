import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/friends_tabs.dart';
import '../../../../../core/theme/app_colors.dart';

class FriendsPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const FriendsPage({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Friends',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              FriendsTab(navigationShell: navigationShell),
              const SizedBox(height: 20),
              Expanded(child: navigationShell),
            ],
          ),
        ),
      ),
    );
  }
}
