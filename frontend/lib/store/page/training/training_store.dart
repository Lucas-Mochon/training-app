import 'package:flutter/material.dart';
import 'package:frontend/models/trainingSession_model.dart';
import 'package:frontend/services/training_service.dart';
import 'package:frontend/store/auth_store.dart';

class Trainingstore extends ChangeNotifier {
  final AuthStore authStore;
  late final TrainingService trainingService;

  List<TrainingSession>? trainings;
  TrainingSession? training;
  bool isLoading = false;
  String? error;

  Trainingstore({required this.authStore}) {
    trainingService = TrainingService(authStore: authStore);
  }

  Future<void> getList() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await trainingService.list();
      trainings = (response['data'] as List)
          .map((item) => TrainingSession.fromJson(item))
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
      if (training?.id != id) {
        if (trainings != null) {
          training = trainings
              ?.where((e) => e.id == id)
              .cast<TrainingSession?>()
              .firstOrNull;
        } else {
          final Map<String, dynamic> response = await trainingService.getOne(
            id,
          );
          training = TrainingSession.fromJson(response['data']);
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
    int duration,
    int feeling,
    String workoutId,
    String userId,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await trainingService.create(
        duration,
        feeling,
        workoutId,
        userId,
      );
      training = TrainingSession.fromJson(response['data']);
      if (training != null) {
        trainings?.add(training!);
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
