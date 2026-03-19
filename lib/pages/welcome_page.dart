import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'login_page.dart';
import 'sign_up_page.dart';
import '../widgets/welcome_buttons.dart';

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

                Image.asset('assets/logos/zvycha-logo-text.png', height: 60),

                const SizedBox(height: 80),
                Image.asset(
                  'assets/images/welcome/welcome-cat.png',
                  height: 280,
                ),

                const SizedBox(height: 70),

                AuthButton(
                  text: 'Log In',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                ),

                const SizedBox(height: 16),

                AuthButton(
                  text: 'Sign Up',
                  isFilled: false,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpPage()),
                    );
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
