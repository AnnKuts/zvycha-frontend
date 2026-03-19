import 'package:go_router/go_router.dart';
import '../pages/welcome_page.dart';
import '../pages/login_page.dart';
import '../pages/sign_up_page.dart';
import '../pages/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final username = state.extra as String? ?? 'User';
        return HomePage(username: username);
      },
    ),
  ],
);
