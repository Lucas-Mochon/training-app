import 'package:flutter/material.dart';
import 'package:frontend/constants/dto/workout_detail.dart';
import 'package:frontend/constants/enum/workout_goal_enum.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:frontend/services/workout_service.dart';
import 'package:frontend/store/auth_store.dart';

class WorkoutStore extends ChangeNotifier {
  final AuthStore authStore;
  late final WorkoutService workoutService;

  List<Workout>? workouts;
  Workout? workout;
  WorkoutDetailResponse? workoutDetail;
  bool isLoading = false;
  String? error;

  WorkoutStore({required this.authStore}) {
    workoutService = WorkoutService(authStore: authStore);
  }

  Future<void> getList(
    String userId,
    int? minDuration,
    int? maxDuration,
    Workoutgoal? goal,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final Map<String, dynamic> response = await workoutService.list(
        userId,
        minDuration,
        maxDuration,
        goal,
      );
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
      final response = await workoutService.getOne(id);
      final data = response['data'];
      print(data);
      workoutDetail = WorkoutDetailResponse.fromJson(data);
      workout = workoutDetail!.workout;
    } catch (e) {
      error = e.toString();
      workoutDetail = null;
      workout = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create(String userId, int duration, Workoutgoal goal) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await workoutService.create(
        userId,
        duration,
        goal,
      );
      Workout work = Workout.fromJson(response['data']);
      workouts?.add(work);
      notifyListeners();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update(String id, int duration, Workoutgoal goal) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await workoutService.update(
        id,
        duration,
        goal,
      );
      Workout work = Workout.fromJson(response['data']);

      final index = workouts?.indexWhere((w) => w.id == id) ?? -1;
      if (index >= 0) {
        workouts?[index] = work;
      }

      workout = work;

      workoutDetail = null;

      notifyListeners();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
