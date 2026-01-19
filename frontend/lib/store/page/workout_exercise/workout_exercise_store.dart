import 'package:flutter/material.dart';
import 'package:frontend/models/workout_exercise.dart';
import 'package:frontend/services/workout_exercise_service.dart';
import 'package:frontend/store/auth_store.dart';
import 'package:frontend/store/page/workout/workout_store.dart';
import 'package:provider/provider.dart';

class WorkoutExerciseStore extends ChangeNotifier {
  final AuthStore authStore;
  late final WorkoutExerciseService workoutExcerciseService;
  late final WorkoutStore workoutStore;

  List<WorkoutExercise>? workoutExcercises;
  WorkoutExercise? workoutExcercise;
  bool isLoading = false;
  String? error;

  WorkoutExerciseStore({required this.authStore}) {
    workoutExcerciseService = WorkoutExerciseService(authStore: authStore);
  }

  Future<void> getOne(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      if (workoutExcercise?.id != id) {
        if (workoutExcercises != null) {
          workoutExcercise = workoutExcercises
              ?.where((w) => w.id == id)
              .cast<WorkoutExercise?>()
              .firstOrNull;
        } else {
          final Map<String, dynamic> response = await workoutExcerciseService
              .getOne(id);
          workoutExcercise = WorkoutExercise.fromJson(response['data']);
        }
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create(
    String workoutId,
    int exerciseId,
    int? sets,
    String? reps,
    int? restSeconds,
    int? orderIndex,
    BuildContext context,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await workoutExcerciseService
          .create(workoutId, exerciseId, sets, reps, restSeconds, orderIndex);
      WorkoutExercise workExo = WorkoutExercise.fromJson(response['data']);
      await context.read<WorkoutStore>().getOne(workExo.workoutId);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update(
    int id,
    int? sets,
    String? reps,
    int? restSeconds,
    int? orderIndex,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await workoutExcerciseService
          .update(id, sets, reps, restSeconds, orderIndex);
      WorkoutExercise workExo = WorkoutExercise.fromJson(response['data']);

      final index = workoutExcercises?.indexWhere((w) => w.id == id) ?? -1;
      if (index >= 0) {
        workoutExcercises?[index] = workExo;
      }

      workoutExcercise = workExo;
      await workoutStore.getOne(workExo.workoutId);
      notifyListeners();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await workoutExcerciseService.deleteById(id);
      if (workoutExcercise?.id == id) {
        workoutExcercise = null;
      }

      final index = workoutExcercises?.indexWhere((w) => w.id == id) ?? -1;

      if (index >= 0) {
        workoutExcercises!.removeAt(index);
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
