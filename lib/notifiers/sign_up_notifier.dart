import 'package:flutter/material.dart';
import '../api/auth_api.dart';
import '../validators/sign_up_validator.dart';

enum SignUpStatus { idle, loading, success, error }

class SignUpNotifier extends ChangeNotifier {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  SignUpStatus _status = SignUpStatus.idle;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _username;

  SignUpStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirm => _obscureConfirm;
  bool get isLoading => _status == SignUpStatus.loading;
  String? get username => _username;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirm() {
    _obscureConfirm = !_obscureConfirm;
    notifyListeners();
  }

  Future<void> signUp() async {
    final error = SignUpValidator.validate(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    if (error != null) {
      _errorMessage = error;
      _status = SignUpStatus.error;
      notifyListeners();
      return;
    }

    _status = SignUpStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthApi.signUp(
        usernameController.text.trim(),
        emailController.text.trim(),
        passwordController.text,
      );
      
      _username = response['name'] ??
                  response['username'] ?? 
                  usernameController.text.trim();

      _status = SignUpStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = SignUpStatus.error;
    }

    notifyListeners();
  }

  void resetStatus() {
    _status = SignUpStatus.idle;
    _errorMessage = null;
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}