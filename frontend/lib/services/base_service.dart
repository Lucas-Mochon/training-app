import 'dart:convert';
import 'package:http/http.dart' as http;
import '../store/auth_store.dart';

class BaseService {
  final String baseUrl;
  final AuthStore authStore;

  BaseService({required this.baseUrl, required this.authStore});

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${authStore.token}',
  };

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);

      if (authStore.refreshToken != null) {
        try {
          final refreshResponse = await http.post(
            Uri.parse('$baseUrl/refresh'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'refreshToken': authStore.refreshToken}),
          );

          if (refreshResponse.statusCode >= 200 &&
              refreshResponse.statusCode < 300) {
            final refreshData = jsonDecode(refreshResponse.body);
            final newToken = refreshData['data']['accessToken'];
            if (newToken != null) {
              await authStore.setToken(newToken);
            }
          } else {
            print(
              'Refresh token failed: ${refreshResponse.statusCode} ${refreshResponse.body}',
            );
          }
        } catch (e) {
          print('Erreur refresh token: $e');
        }
      }

      return data;
    } else {
      throw Exception('Erreur ${response.statusCode} : ${response.body}');
    }
  }
}
