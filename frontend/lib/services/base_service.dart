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
    if (authStore.token != null) 'Authorization': 'Bearer ${authStore.token}',
  };

  Future<dynamic> get(String endpoint) {
    return _request(() {
      return http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    });
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) {
    return _request(() {
      return http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
    });
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) {
    return _request(() {
      return http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
    });
  }

  Future<dynamic> delete(String endpoint) {
    return _request(() {
      return http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
    });
  }

  Future<dynamic> _request(Future<http.Response> Function() requestFn) async {
    http.Response response = await requestFn();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return _decode(response);
    }

    if (response.statusCode == 401) {
      final refreshed = await _refreshToken();

      if (refreshed) {
        response = await requestFn();

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return _decode(response);
        }
      }

      await authStore.clearTokens();
      throw Exception('Session expirée');
    }

    throw Exception('Erreur ${response.statusCode} : ${response.body}');
  }

  Future<bool> _refreshToken() async {
    if (authStore.refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users/refresh'),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'refreshToken': authStore.refreshToken}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final newToken = data['data']?['accessToken'];

        if (newToken != null) {
          await authStore.setToken(newToken);
          return true;
        }
      }
    } catch (_) {}

    return false;
  }

  dynamic _decode(http.Response response) {
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }
}
