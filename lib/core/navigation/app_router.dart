import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zvycha_frontend/core/navigation/route_names.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../widgets/home_loader.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';

final appRouter = GoRouter(
  initialLocation: AppPages.welcome.path,
  refreshListenable: authNotifier,
  redirect: (context, state) {
    if (authNotifier.status == AuthStatus.loading &&
        state.matchedLocation != AppPages.loading.path) {
      return AppPages.loading.path;
    }

    final loggedIn = authNotifier.isLoggedIn;
    final authRoutes = [
      AppPages.welcome.path,
      AppPages.login.path,
      AppPages.signup.path,
    ];
    final onAuthRoute = authRoutes.contains(
      state.matchedLocation,
    );

    if (loggedIn && onAuthRoute) {
      return AppPages.home.path;
    }
    if (!loggedIn &&
        !onAuthRoute &&
        state.matchedLocation != AppPages.loading.path) {
      return AppPages.welcome.path;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppPages.loading.path,
      builder: (context, state) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    ),

    GoRoute(
      path: AppPages.welcome.path,
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: AppPages.login.path,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppPages.signup.path,
      builder: (context, state) => const SignUpPage(),
    ),

    GoRoute(
      path: AppPages.home.path,
      builder: (context, state) {
        final username = state.extra is String
            ? state.extra as String
            : null;
        return HomeLoader(usernameHint: username);
      },
    ),
  ],
);
