import 'package:flutter/material.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/services/workout_service.dart';
import 'package:frontend/store/auth_store.dart';

class WorkoutStore extends ChangeNotifier {
  final AuthStore authStore;
  late final WorkoutService workoutService;

  List<Workout>? workouts;
  Workout? workout;
  bool isLoading = false;
  String? error;

  WorkoutStore({required this.authStore}) {
    workoutService = WorkoutService(authStore: authStore);
  }

  Future<void> getList(String userId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await workoutService.list(userId);
      workouts = (response['data'] as List)
          .map((item) => Workout.fromJson(item))
          .toList();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOne(String id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      if (workout?.id != id) {
        if (workouts != null) {
          workout = workouts
              ?.where((w) => w.id == id)
              .cast<Workout?>()
              .firstOrNull;
        } else {
          final Map<String, dynamic> response = await workoutService.getOne(id);
          workout = Workout.fromJson(response['data']);
        }
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
