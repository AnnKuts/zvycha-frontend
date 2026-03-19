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
    final loggedIn = authNotifier.isLoggedIn;
    final onAuthRoute =
        state.matchedLocation == '/welcome' ||
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/signup';

    if (loggedIn && onAuthRoute) {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomePage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final username = state.extra as String?;
        return HomeLoader(usernameHint: username);
      },
    ),
  ],
);
