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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleStatusChange(
    BuildContext context,
    AuthFormNotifier notifier,
  ) {
    switch (notifier.status) {
      case AuthStatus.success:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        notifier.resetStatus();
        context.go(AppPages.home.path);
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
                        const SizedBox(height: 100),
                        AppTextField(
                          label: 'Email',
                          hint: 'example@example.com',
                          controller: _emailController,
                          keyboardType:
                              TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        PasswordField(
                          controller: _passwordController,
                          obscure: _obscurePassword,
                          onToggle: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: AuthButtonDark(
                            text: 'Log In',
                            onPressed: () => notifier.login(
                              _emailController.text,
                              _passwordController.text,
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
