import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/store/auth_store.dart';

class ProfileStore extends ChangeNotifier {
  final AuthStore authStore;
  late final UserService userService;

  Map<String, dynamic>? user;
  bool isLoading = false;
  String? error;

  ProfileStore({required this.authStore}) {
    userService = UserService(authStore: authStore);
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await userService.getMe();
      user = response['data'];
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    authStore.clearTokens();
  }
}
