import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStore extends ChangeNotifier {
  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  AuthStore() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await _storage.read(key: _tokenKey);
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    _token = token;
    await _storage.write(key: _tokenKey, value: token);
    notifyListeners();
  }

  Future<void> clearToken() async {
    _token = null;
    await _storage.delete(key: _tokenKey);
    notifyListeners();
  }
}
