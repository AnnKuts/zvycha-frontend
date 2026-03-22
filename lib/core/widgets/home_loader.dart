import 'package:flutter/material.dart';
import '../../features/rooms/presentation/pages/home_page.dart';
import '../services/auth_storage.dart';

class HomeLoader extends StatefulWidget {
  final String? usernameHint;
  const HomeLoader({super.key, this.usernameHint});

  @override
  State<HomeLoader> createState() => _HomeLoaderState();
}

class _HomeLoaderState extends State<HomeLoader> {
  String? _username;

  @override
  void initState() {
    super.initState();
    if (widget.usernameHint != null) {
      _username = widget.usernameHint;
    } else {
      _loadUsername();
    }
  }

  Future<void> _loadUsername() async {
    final name = await AuthStorage.getUsername();
    if (mounted) setState(() => _username = name ?? 'User');
  }

  @override
  Widget build(BuildContext context) {
    if (_username == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return HomePage(username: _username!);
  }
}
