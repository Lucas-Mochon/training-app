import 'package:flutter/material.dart';
import 'package:frontend/services/exercise_service.dart';
import 'package:frontend/store/auth_store.dart';

class ExerciseStore extends ChangeNotifier {
  final AuthStore authStore;
  late final ExerciseService exerciseService;

  List<Map<String, dynamic>>? exercises;
  bool isLoading = false;
  String? error;

  ExerciseStore({required this.authStore}) {
    exerciseService = ExerciseService(authStore: authStore);
    getList();
  }

  Future<void> getList() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await exerciseService.list();
      exercises = List<Map<String, dynamic>>.from(response['data']);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    authStore.clearTokens();
  }
}
