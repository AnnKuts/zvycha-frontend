import 'package:flutter/material.dart';
import '../api/auth_api.dart';
import '../validators/login_validator.dart';

enum LoginStatus { idle, loading, success, error }

class LoginNotifier extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginStatus _status = LoginStatus.idle;
  String? _errorMessage;
  bool _obscurePassword = true;

  LoginStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _status == LoginStatus.loading;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> login() async {
    final error = LoginValidator.validate(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (error != null) {
      _errorMessage = error;
      _status = LoginStatus.error;
      notifyListeners();
      return;
    }

    _status = LoginStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await AuthApi.login(
        emailController.text.trim(),
        passwordController.text,
      );

      // TODO: save token here

      _status = LoginStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = LoginStatus.error;
    }

    notifyListeners();
  }

  void resetStatus() {
    _status = LoginStatus.idle;
    _errorMessage = null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}