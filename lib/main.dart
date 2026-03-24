import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zvycha_frontend/features/rooms/data/rooms_repository.dart';
import 'package:zvycha_frontend/features/rooms/data/rooms_api_service.dart';
import 'package:zvycha_frontend/features/rooms/presentation/providers/rooms_notifier.dart';

import './core/network/api_client.dart';
import './core/theme/app_theme.dart';
import './core/navigation/app_router.dart';

import './features/auth/data/auth_api.dart';
import './features/auth/data/auth_repository.dart';
import './features/auth/presentation/providers/auth_form_notifier.dart';
import './features/auth/presentation/providers/auth_notifier.dart';

import './features/friends/data/friends_api_service.dart';
import './features/friends/data/friends_repository.dart';
import './features/friends/presentations/providers/friends_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final apiClient = ApiClient();

  final authApi = AuthApi(apiClient);
  final authRepository = AuthRepository(authApi);
  final authNotifier = AuthNotifier();
  await authNotifier.init();

  final router = createRouter(authNotifier);

  final friendsApi = FriendsApiService(apiClient);

  final roomService = RoomsApiService(apiClient);
  final roomRepository = RoomsRepository(roomService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>.value(
          value: authNotifier,
        ),
        ChangeNotifierProvider<AuthFormNotifier>(
          create: (_) =>
              AuthFormNotifier(authNotifier, authRepository),
        ),
        Provider<FriendsRepository>(
          create: (_) => FriendsRepository(friendsApi),
        ),
        ChangeNotifierProvider<FriendsNotifier>(
          create: (context) => FriendsNotifier(
            Provider.of<FriendsRepository>(
              context,
              listen: false,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              RoomsNotifier(roomRepository)..loadInitialData(),
        ),
      ],
      child: MyApp(router: router),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'zvycha',
      theme: AppTheme.lightTheme,
    );
  }
}
