import 'package:flutter/material.dart';
import '../services/auth_storage.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  Future<void> init() async {
    _isLoggedIn = await AuthStorage.isLoggedIn();
    if (_isLoggedIn) {
      _username = await AuthStorage.getUsername();
    }
    notifyListeners();
  }

  Future<void> login(String token, String username) async {
    await AuthStorage.save(token: token, username: username);
    _isLoggedIn = true;
    _username = username;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthStorage.clear();
    _isLoggedIn = false;
    _username = null;
    notifyListeners();
  }
}

final authNotifier = AuthNotifier();
