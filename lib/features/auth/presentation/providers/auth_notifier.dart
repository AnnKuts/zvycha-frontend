import 'package:flutter/material.dart';
import 'package:zvycha_frontend/features/friends/presentations/providers/friends_notifier.dart';
import '../../../../core/services/auth_storage.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthNotifier extends ChangeNotifier {
  AuthStatus _status = AuthStatus.loading;
  String? _username;
  String? _userId;

  AuthStatus get status => _status;
  bool get isLoggedIn => _status == AuthStatus.authenticated;
  String? get username => _username;
  String? get userId => _userId;

  Future<void> init() async {
    final loggedIn = await AuthStorage.isLoggedIn();
    if (loggedIn) {
      _username = await AuthStorage.getUsername();
      _userId = await AuthStorage.getUserId();
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login(
    String token,
    String username,
    String userId,
  ) async {
    await AuthStorage.save(
      token: token,
      username: username,
      userId: userId,
    );
    _userId = userId;
    _username = username;
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthStorage.clear();
    _status = AuthStatus.unauthenticated;
    _username = null;
    _userId = null;
    notifyListeners();
  }
}
