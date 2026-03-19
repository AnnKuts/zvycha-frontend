import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../notifiers/login_notifier.dart';
import '../widgets/text_field.dart';
import '../widgets/auth_buttons.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginNotifier(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  void _handleStatusChange(BuildContext context, LoginNotifier notifier) {
    switch (notifier.status) {
      case LoginStatus.success:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        notifier.resetStatus();
    // TODO: navigate to home
      case LoginStatus.error:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(notifier.errorMessage ?? 'Unknown error')),
        );
        notifier.resetStatus();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/auth/bg-vector.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/auth/bg-vector-login.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Consumer<LoginNotifier>(
                  builder: (context, notifier, _) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _handleStatusChange(context, notifier);
                    });

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _Header(),
                        const SizedBox(height: 100),
                        AppTextField(
                          label: 'Email',
                          hint: 'example@example.com',
                          controller: notifier.emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        _PasswordField(
                          controller: notifier.passwordController,
                          obscure: notifier.obscurePassword,
                          onToggle: notifier.toggleObscurePassword,
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: AuthButtonDark(
                            text: 'Log In',
                            onPressed: notifier.login,
                            isLoading: notifier.isLoading,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: 28,
            color: AppColors.primary,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Log In',
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

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: 'Password',
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