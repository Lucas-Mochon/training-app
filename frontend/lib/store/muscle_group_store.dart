import 'package:flutter/material.dart';
import 'package:frontend/models/muscleGroup_model.dart';
import 'package:frontend/services/muscle_group_service.dart';
import 'package:frontend/store/auth_store.dart';

class MuscleGroupStore extends ChangeNotifier {
  final AuthStore authStore;
  late final MuscleGroupService muscleGroupService;

  List<MuscleGroup>? muscleGroups;
  bool isLoading = false;
  String? error;

  MuscleGroupStore({required this.authStore}) {
    muscleGroupService = MuscleGroupService(authStore: authStore);
  }

  Future<void> getList() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await muscleGroupService.list();
      muscleGroups = (response['data'] as List)
          .map((item) => MuscleGroup.fromJson(item))
          .toList();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
