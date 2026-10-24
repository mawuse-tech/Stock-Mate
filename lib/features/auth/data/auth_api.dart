import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_config.dart';
import 'auth_models.dart';

class AuthApi {
  AuthApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> authenticate(
    String path,
    Map<String, String> body,
  ) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/$path'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _data(response);
  }

  Future<AuthUser> currentUser(String token) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}/auth/me'),
      headers: _headers(token),
    );
    return AuthUser.fromJson(_data(response)['user'] as Map<String, dynamic>);
  }

  Future<void> logout(String token) async {
    await _client.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/logout'),
      headers: _headers(token),
    );
  }

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Map<String, dynamic> _data(http.Response response) {
    Map<String, dynamic> payload;
    try {
      payload = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw const AuthException('Could not read the server response.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(
        payload['message']?.toString() ?? 'Request failed. Try again.',
        statusCode: response.statusCode,
      );
    }
    return payload['data'] as Map<String, dynamic>? ?? payload;
  }
}
