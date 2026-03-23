import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/auth_storage.dart';

class ApiClient {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<Map<String, String>> _getHeaders() async {
    final token = await AuthStorage.getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return body;
    } else {
      final message = body['detail'] is List
          ? body['detail'][0]['msg']
          : body['detail'] ?? 'Failed';
      throw Exception(message);
    }
  }

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _getHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _getHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _getHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }
}
