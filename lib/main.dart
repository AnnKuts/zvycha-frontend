import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:zvycha_frontend/constants/app_theme.dart';
import 'package:zvycha_frontend/router/app_router.dart';
import 'package:zvycha_frontend/notifiers/auth_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await authNotifier.init();

  runApp(
    ChangeNotifierProvider.value(value: authNotifier, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'zvycha',
      theme: AppTheme.lightTheme,
    );
  }
}
