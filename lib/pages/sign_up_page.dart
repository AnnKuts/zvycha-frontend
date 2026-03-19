import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../notifiers/sign_up_notifier.dart';
import '../widgets/text_field.dart';
import '../widgets/auth_buttons.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpNotifier(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView();

  void _handleStatusChange(BuildContext context, SignUpNotifier notifier) {
    switch (notifier.status) {
      case SignUpStatus.success:
        final currentUsername = notifier.username;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        notifier.resetStatus();
        context.go('/home', extra: currentUsername);
      case SignUpStatus.error:
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
            right: 0,
            child: Image.asset(
              'assets/images/auth/bg-vector-signup.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Consumer<SignUpNotifier>(
                  builder: (context, notifier, _) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _handleStatusChange(context, notifier);
                    });

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _Header(),
                        const SizedBox(height: 80),
                        AppTextField(
                          label: 'Username',
                          hint: 'example',
                          controller: notifier.usernameController,
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          label: 'Email',
                          hint: 'example@example.com',
                          controller: notifier.emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        _PasswordField(
                          label: 'Password',
                          controller: notifier.passwordController,
                          obscure: notifier.obscurePassword,
                          onToggle: notifier.toggleObscurePassword,
                        ),
                        const SizedBox(height: 12),
                        _PasswordField(
                          label: 'Confirm Password',
                          controller: notifier.confirmPasswordController,
                          obscure: notifier.obscureConfirm,
                          onToggle: notifier.toggleObscureConfirm,
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: AuthButtonDark(
                            text: 'Sign Up',
                            onPressed: notifier.signUp,
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
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/welcome');
            }
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 28,
            color: AppColors.primary,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Sign Up',
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
    required this.label,
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