import 'package:flutter/material.dart';
import 'package:zvycha_frontend/core/navigation/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/welcome_buttons.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome/background-circles.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 100),

                Image.asset(
                  'assets/logos/zvycha-logo-text.png',
                  height: 60,
                ),

                const SizedBox(height: 80),
                Image.asset(
                  'assets/images/welcome/welcome-cat.png',
                  height: 280,
                ),

                const SizedBox(height: 70),

                AuthButton(
                  text: 'Log In',
                  onPressed: () {
                    context.push(AppPages.login.path);
                  },
                ),

                const SizedBox(height: 16),

                AuthButton(
                  text: 'Sign Up',
                  isFilled: false,
                  onPressed: () {
                    context.push(AppPages.signup.path);
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
