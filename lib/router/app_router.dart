import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/welcome_page.dart';
import '../pages/login_page.dart';
import '../pages/sign_up_page.dart';
import '../widgets/home_loader.dart';
import '../notifiers/auth_notifier.dart';

final appRouter = GoRouter(
  initialLocation: '/welcome',
  refreshListenable: authNotifier,
  redirect: (context, state) {
    if (authNotifier.status == AuthStatus.loading &&
        state.matchedLocation != '/loading') {
      return '/loading';
    }

    final loggedIn = authNotifier.isLoggedIn;
    final authRoutes = ['/welcome', '/login', '/signup'];
    final onAuthRoute = authRoutes.contains(state.matchedLocation);

    if (loggedIn && onAuthRoute) {
      return '/home';
    }

    if (!loggedIn && !onAuthRoute && state.matchedLocation != '/loading') {
      return '/welcome';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/loading',
      builder: (context, state) =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomePage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final username = state.extra is String ? state.extra as String : null;
        return HomeLoader(usernameHint: username);
      },
    ),
  ],
);
