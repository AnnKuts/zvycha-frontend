import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zvycha_frontend/core/navigation/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_form_notifier.dart';
import '../../../../core/widgets/text_field.dart';
import '../widgets/password_field.dart';
import '../widgets/auth_buttons.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AuthFormNotifier>().resetStatus();
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleStatusChange(
    BuildContext context,
    AuthFormNotifier notifier,
  ) {
    switch (notifier.status) {
      case AuthStatus.success:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
          ),
        );
        notifier.resetStatus();
        context.go(AppPages.rooms.path);
        break;

      case AuthStatus.error:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              notifier.errorMessage ?? 'Unknown error',
            ),
          ),
        );
        notifier.resetStatus();
        break;

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                ),
                child: Consumer<AuthFormNotifier>(
                  builder: (context, notifier, _) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        _handleStatusChange(context, notifier);
                      },
                    );

                    return Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _Header(),
                        const SizedBox(height: 80),
                        AppTextField(
                          label: 'Username',
                          hint: 'example',
                          controller: _usernameController,
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          label: 'Email',
                          hint: 'example@example.com',
                          controller: _emailController,
                          keyboardType:
                              TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        PasswordField(
                          label: 'Password',
                          controller: _passwordController,
                          obscure: _obscurePassword,
                          onToggle: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        PasswordField(
                          label: 'Confirm Password',
                          controller: _confirmPasswordController,
                          obscure: _obscureConfirm,
                          onToggle: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: AuthButtonDark(
                            text: 'Sign Up',
                            onPressed: () => notifier.signUp(
                              _usernameController.text,
                              _emailController.text,
                              _passwordController.text,
                              _confirmPasswordController.text,
                            ),
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
              context.go(AppPages.welcome.path);
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
