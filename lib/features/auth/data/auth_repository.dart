import 'auth_api.dart';

class AuthRepository {
  final AuthApi _authApi;

  AuthRepository(this._authApi);

  Future<Map<String, String>> login(
    String email,
    String password,
  ) async {
    final response = await _authApi.login(email, password);
    return _processResponse(response, email.split('@').first);
  }

  Future<Map<String, String>> signUp(
    String username,
    String email,
    String password,
  ) async {
    final response = await _authApi.signUp(username, email, password);
    return _processResponse(response, username);
  }

  Future<Map<String, String>> _processResponse(
    Map<String, dynamic> response,
    String defaultUsername,
  ) async {
    final token = response['token'] ?? response['access_token'];

    if (token == null || token.toString().trim().isEmpty) {
      throw Exception(
        'Authentication failed: missing token from server.',
      );
    }

    final username =
        response['name'] ??
        response['username'] ??
        defaultUsername;

    return {
      'token': token.toString(),
      'username': username.toString(),
    };
  }
}
