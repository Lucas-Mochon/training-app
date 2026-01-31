import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStore extends ChangeNotifier {
  static const _accessTokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _roleKey = 'role';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _accessToken;
  String? _refreshToken;
  String? _role;

  String? get token => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isAuthenticated => _accessToken != null;
  String? get role => _role;

  AuthStore() {
    _loadTokens();
    _loadRole();
  }

  Future<void> _loadTokens() async {
    _accessToken = await _storage.read(key: _accessTokenKey);
    _refreshToken = await _storage.read(key: _refreshTokenKey);
    notifyListeners();
  }

  Future<void> _loadRole() async {
    _role = await _storage.read(key: _roleKey);
  }

  Future<void> setRole(String role) async {
    _role = role;
    await _storage.write(key: _roleKey, value: role);
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    _accessToken = token;
    await _storage.write(key: _accessTokenKey, value: token);
    notifyListeners();
  }

  Future<void> setRefreshToken(String token) async {
    _refreshToken = token;
    await _storage.write(key: _refreshTokenKey, value: token);
    notifyListeners();
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    notifyListeners();
  }
}
