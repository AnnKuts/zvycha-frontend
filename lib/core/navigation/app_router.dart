import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zvycha_frontend/core/navigation/route_names.dart';
import 'package:zvycha_frontend/features/main/presentation/pages/main_shell_page.dart';
import 'package:zvycha_frontend/features/rooms/presentation/pages/rooms_page.dart';
import 'package:zvycha_frontend/settings_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _roomsNavigatorKey = GlobalKey<NavigatorState>();
final _invitationsNavigatorKey = GlobalKey<NavigatorState>();
final _friendsNavigatorKey = GlobalKey<NavigatorState>();
final _settingsNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: AppPages.welcome.path,
  navigatorKey: _rootNavigatorKey,
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

    // BottomNavigationBar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShellPage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _roomsNavigatorKey,
          routes: [
            GoRoute(
              path: AppPages.rooms.path,
              builder: (context, state) => const RoomsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _invitationsNavigatorKey,
          routes: [
            GoRoute(
              path: AppPages.invitations.path,
              // builder: (context, state) => const InvitationsPage(),
              builder: (context, state) =>
                  const Center(child: Text("Invitations")),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _friendsNavigatorKey,
          routes: [
            GoRoute(
              path: AppPages.friends.path,
              builder: (context, state) =>
                  const Center(child: Text("Friends")),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [
            GoRoute(
              path: AppPages.settings.path,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
