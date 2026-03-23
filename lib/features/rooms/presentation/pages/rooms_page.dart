import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zvycha_frontend/features/auth/presentation/providers/auth_notifier.dart';
import '../../../../core/theme/app_colors.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 32,
            left: 24,
            right: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<AuthNotifier>(
                builder: (context, auth, child) {
                  return Text(
                    'Hi, ${auth.username ?? 'User'}!',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge,
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text("Ваші кімнати..."),
            ],
          ),
        ),
      ),
    );
  }
}
