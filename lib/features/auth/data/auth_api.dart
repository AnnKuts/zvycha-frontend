import 'dart:convert';
import '../../../core/network/api_client.dart';

class AuthApi {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await ApiClient.post(
      '/users/login',
      body: {'email': email, 'password': password},
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return body;
    } else {
      throw Exception(body['detail'] ?? 'Login failed');
    }
  }

  static Future<Map<String, dynamic>> signUp(
    String name,
    String email,
    String password,
  ) async {
    final response = await ApiClient.post(
      '/users/sign_up',
      body: {'name': name, 'email': email, 'password': password},
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return body;
    } else {
      throw Exception(body['detail'] ?? 'Sign up failed');
    }
  }
}
