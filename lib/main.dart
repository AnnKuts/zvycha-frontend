import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import './core/network/api_client.dart';
import './core/theme/app_theme.dart';
import './core/navigation/app_router.dart';

import './features/auth/data/auth_api.dart';
import 'features/auth/data/auth_repository.dart';
import './features/auth/presentation/providers/auth_form_notifier.dart';
import './features/auth/presentation/providers/auth_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final apiClient = ApiClient();

  final authApi = AuthApi(apiClient);
  final authRepository = AuthRepository(authApi);

  final authNotifier = AuthNotifier();

  await authNotifier.init();

  final router = createRouter(authNotifier);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>.value(
          value: authNotifier,
        ),
        ChangeNotifierProvider<AuthFormNotifier>(
          create: (_) => AuthFormNotifier(authNotifier, authRepository),
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
