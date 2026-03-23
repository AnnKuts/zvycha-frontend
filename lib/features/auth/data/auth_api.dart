import '../../../core/network/api_client.dart';

class AuthApi {
  final ApiClient _client;
  AuthApi(this._client);

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    return await _client.post(
      '/users/login',
      body: {'email': email, 'password': password},
    );
  }

  Future<Map<String, dynamic>> signUp(
    String username,
    String email,
    String password,
  ) async {
    return await _client.post(
      '/users/sign_up',
      body: {'username': username, 'email': email, 'password': password},
    );
  }
}
