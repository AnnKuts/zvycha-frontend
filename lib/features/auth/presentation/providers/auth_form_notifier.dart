import 'package:flutter/material.dart';
import '../../data/auth_service.dart';
import '../utils/validators/login_validator.dart';
import '../utils/validators/sign_up_validator.dart';
import 'auth_notifier.dart';

enum AuthStatus { idle, loading, success, error }

class AuthFormNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;
  AuthFormNotifier(this._authNotifier);

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  String? _username;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;
  String? get username => _username;

  Future<void> login(String email, String password) async {
    final error = LoginValidator.validate(email: email, password: password);
    if (error != null) {
      _setError(error);
      return;
    }

    _setLoading();
    try {
      final result = await AuthService.login(email, password);
      await _authNotifier.login(result['token']!, result['username']!);

      _username = result['username'];
      _setSuccess();
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> signUp(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final error = SignUpValidator.validate(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    if (error != null) {
      _setError(error);
      return;
    }

    _setLoading();
    try {
      final result = await AuthService.signUp(username, email, password);
      await _authNotifier.login(result['token']!, result['username']!);
      
      _username = result['username'];
      _setSuccess();
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void resetStatus() {
    if (_status != AuthStatus.idle) {
      _status = AuthStatus.idle;
      _errorMessage = null;
    }
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = AuthStatus.success;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
