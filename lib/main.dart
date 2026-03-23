import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zvycha_frontend/core/theme/app_theme.dart';
import 'package:zvycha_frontend/core/navigation/app_router.dart';
import 'package:zvycha_frontend/features/auth/presentation/providers/auth_form_notifier.dart';
import 'package:zvycha_frontend/features/auth/presentation/providers/auth_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final authNotifier = AuthNotifier();
  await authNotifier.init();

  final router = createRouter(authNotifier);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>.value(value: authNotifier),
        ChangeNotifierProxyProvider<AuthNotifier, AuthFormNotifier>(
          create: (context) => AuthFormNotifier(authNotifier),
          update: (context, auth, previous) => previous ?? AuthFormNotifier(auth),
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
