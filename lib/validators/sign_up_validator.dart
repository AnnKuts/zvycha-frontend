class SignUpValidator {
  static String? validate({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return 'Please fill in all fields';
    }
    //залежно від нашої логіки потім помінять нормально
    if (username.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (!RegExp(r'^[\w-.]+@[\w-]+\.[a-z]{2,}$').hasMatch(email)) {
      return 'Invalid email format';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }
}
