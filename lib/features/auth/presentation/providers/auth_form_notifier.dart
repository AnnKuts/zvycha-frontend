import 'package:flutter/material.dart';
import '../../data/auth_repository.dart';
import '../utils/validators/login_validator.dart';
import '../utils/validators/sign_up_validator.dart';
import 'auth_notifier.dart';

enum FormStatus { idle, loading, success, error }

class AuthFormNotifier extends ChangeNotifier {
  final AuthRepository _authRepository;
  final AuthNotifier _authNotifier;

  AuthFormNotifier(this._authNotifier, this._authRepository);

  FormStatus _status = FormStatus.idle;
  String? _errorMessage;
  String? _username;

  FormStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == FormStatus.loading;
  String? get username => _username;

  Future<void> login(String email, String password) async {
    final error = LoginValidator.validate(
      email: email,
      password: password,
    );
    if (error != null) {
      _setError(error);
      return;
    }

    _setLoading();
    try {
      final result = await _authRepository.login(email, password);
      await _authNotifier.login(
        result['token']!,
        result['username']!,
      );

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
      final result = await _authRepository.signUp(
        username,
        email,
        password,
      );
      await _authNotifier.login(
        result['token']!,
        result['username']!,
      );

      _username = result['username'];
      _setSuccess();
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void resetStatus() {
    if (_status != FormStatus.idle) {
      _status = FormStatus.idle;
      _errorMessage = null;
    }
  }

  void _setLoading() {
    _status = FormStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = FormStatus.success;
    notifyListeners();
  }

  void _setError(String message) {
    _status = FormStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
