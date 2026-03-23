import 'package:flutter/material.dart';
import '../../../../core/services/auth_storage.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthNotifier extends ChangeNotifier {
  AuthStatus _status = AuthStatus.loading;
  String? _username;

  AuthStatus get status => _status;
  bool get isLoggedIn => _status == AuthStatus.authenticated;
  String? get username => _username;

  Future<void> init() async {
    final loggedIn = await AuthStorage.isLoggedIn();
    if (loggedIn) {
      _username = await AuthStorage.getUsername();
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login(String token, String username) async {
    await AuthStorage.save(token: token, username: username);
    _status = AuthStatus.authenticated;
    _username = username;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthStorage.clear();
    _status = AuthStatus.unauthenticated;
    _username = null;
    notifyListeners();
  }
}

//final authNotifier = AuthNotifier();
