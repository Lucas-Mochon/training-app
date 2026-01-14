import 'package:flutter/material.dart';
import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/services/exercise_service.dart';
import 'package:frontend/store/auth_store.dart';

class ExerciseStore extends ChangeNotifier {
  final AuthStore authStore;
  late final ExerciseService exerciseService;

  List<Exercise>? exercises;
  Exercise? exercise;
  bool isLoading = false;
  String? error;

  ExerciseStore({required this.authStore}) {
    exerciseService = ExerciseService(authStore: authStore);
  }

  Future<void> getList() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await exerciseService.list();
      exercises = (response['data'] as List)
          .map((item) => Exercise.fromJson(item))
          .toList();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOne(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      if (exercise?.id != id) {
        if (exercises != null) {
          exercise = exercises
              ?.where((e) => e.id == id)
              .cast<Exercise?>()
              .firstOrNull;
        } else {
          final Map<String, dynamic> response = await exerciseService.getOne(
            id,
          );
          exercise = Exercise.fromJson(response['data']);
        }
      }
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
