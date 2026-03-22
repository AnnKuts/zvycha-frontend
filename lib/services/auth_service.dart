import '../api/auth_api.dart';

class AuthService {
  static Future<Map<String, String>> login(
    String email,
    String password,
  ) async {
    final response = await AuthApi.login(email, password);
    return _processResponse(response, email.split('@').first);
  }

  static Future<Map<String, String>> signUp(
    String username,
    String email,
    String password,
  ) async {
    final response = await AuthApi.signUp(username, email, password);
    return _processResponse(response, username);
  }

  static Future<Map<String, String>> _processResponse(
    Map<String, dynamic> response,
    String defaultUsername,
  ) async {
    final token = response['token'] ?? response['access_token'];

    if (token == null || token.toString().trim().isEmpty) {
      throw Exception('Authentication failed: missing token from server.');
    }

    final username =
        response['name'] ?? response['username'] ?? defaultUsername;

    return {'token': token.toString(), 'username': username.toString()};
  }
}
