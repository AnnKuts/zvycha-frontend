import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/rooms/presentation/pages/accept_invitation_page.dart';
import '../../features/rooms/presentation/pages/choose_friend_page.dart';
import '../../features/rooms/presentation/pages/create_room_page.dart';
import '../../features/rooms/presentation/pages/invitations_page.dart';
import '../../features/rooms/presentation/pages/invitations_received_page.dart';
import '../../features/rooms/presentation/pages/invitations_sent_page.dart';
import '../../features/rooms/presentation/pages/room_details_page.dart';
import 'route_names.dart';
import '../../features/friends/presentations/pages/friends_find_page.dart';
import '../../features/friends/presentations/pages/friends_page.dart';
import '../../features/friends/presentations/pages/friends_yours_page.dart';
import '../../features/main/presentation/pages/main_shell_page.dart';
import '../../features/rooms/presentation/pages/rooms_page.dart';
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

GoRouter createRouter(AuthNotifier authNotifier) {
  return GoRouter(
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
        return AppPages.rooms.path;
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
                routes: [
                  GoRoute(
                    path: AppPages.roomDetails.path,
                    name: AppPages.roomDetails.name,
                    builder: (context, state) {
                      final roomId =
                          state.pathParameters['roomId']!;
                      return RoomDetailsPage(roomId: roomId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _invitationsNavigatorKey,
            routes: [
              StatefulShellRoute.indexedStack(
                builder: (context, state, navigationShell) =>
                    InvitationsPage(
                      navigationShell: navigationShell,
                    ),
                branches: [
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: AppPages.invitationsReceived.path,
                        builder: (context, state) =>
                            const InvitationsReceivedPage(),
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: AppPages.invitationsSent.path,
                        builder: (context, state) =>
                            const InvitationsSentPage(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _friendsNavigatorKey,
            routes: [
              StatefulShellRoute.indexedStack(
                builder: (context, state, navigationShell) {
                  return FriendsPage(
                    navigationShell: navigationShell,
                  );
                },
                branches: [
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: AppPages.friendsFind.path,
                        builder: (context, state) =>
                            const FriendsYoursPage(),
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: AppPages.friendsYours.path,
                        builder: (context, state) =>
                            const FriendsFindPage(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: AppPages.settings.path,
                builder: (context, state) =>
                    const SettingsPage(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: AppPages.createRoom.path,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateRoomPage(),
      ),
      GoRoute(
        path: AppPages.chooseFriend.path,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChooseFriendPage(),
      ),

      GoRoute(
        path: AppPages.acceptInvitation.path,
        name: AppPages.acceptInvitation.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;

          final data = state.extra as Map<String, dynamic>;

          return AcceptInvitationPage(
            roomId: roomId,
            roomName: data['roomName'] as String,
            senderName: data['senderName'] as String,
          );
        },
      ),
    ],
  );
}
