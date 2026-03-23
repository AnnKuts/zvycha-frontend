class LoginValidator {
  static String? validate({required String email, required String password}) {
    if (email.isEmpty || password.isEmpty) {
      return 'Please fill in all fields';
    }

    if (!RegExp(r'^[\w-.]+@[\w-]+\.[a-z]{2,}$').hasMatch(email)) {
      return 'Invalid email format';
    }

    return null;
  }
}
