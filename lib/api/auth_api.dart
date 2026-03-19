import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String _baseUrl = 'http://10.0.2.2:8000';

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return body;
    } else {
      throw Exception(body['detail'] ?? 'Login failed');
    }
  }

  static Future<Map<String, dynamic>> signUp(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/sign_up'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return body;
    } else {
      throw Exception(body['detail'] ?? 'Sign up failed');
    }
  }
}
