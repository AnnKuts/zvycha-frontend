import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthApi {
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
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
    final response = await http.post(
      Uri.parse('$_baseUrl/users/sign_up'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return body;
    } else {
      throw Exception(body['detail'] ?? 'Sign up failed');
    }
  }
}
