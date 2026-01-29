import 'package:flutter/material.dart';
import 'package:frontend/constants/enum/exercise_difficulty_enum.dart';
import 'package:frontend/constants/enum/exercise_equipment_enum.dart';
import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/services/exercise_service.dart';
import 'package:frontend/store/auth_store.dart';

class ExerciseStore extends ChangeNotifier {
  final AuthStore authStore;
  late final ExerciseService exerciseService;

  List<Exercise>? exercises;
  List<Exercise>? filteredExercises;
  Exercise? exercise;
  bool isLoading = false;
  String? error;

  // 👇 Filtres
  String searchQuery = '';
  Exercisedifficulty? selectedDifficulty;
  ExerciseEquipment? selectedEquipment;
  bool? isCompoundFilter;

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
      _applyFilters();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOne(int id, {bool forceRefresh = false}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      if (forceRefresh || exercise?.id != id) {
        if (!forceRefresh && exercises != null) {
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

  Future<void> create(
    String name,
    Exercisedifficulty difficulty,
    bool isCompound,
    ExerciseEquipment equipment,
    String? description,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await exerciseService.create({
        'name': name,
        'difficulty': difficulty.value,
        'is_compound': isCompound,
        'equipment': equipment.value,
        if (description != null && description.isNotEmpty)
          'description': description,
      });

      final newExercise = Exercise.fromJson(response['data']);
      exercises?.add(newExercise);
      _applyFilters();
      exercise = newExercise;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update(
    int id,
    String? name,
    Exercisedifficulty? difficulty,
    bool? isCompound,
    ExerciseEquipment? equipment,
    String? description,
  ) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final Map<String, dynamic> data = {'id': id};

      if (name != null && name.isNotEmpty) data['name'] = name;
      if (difficulty != null) data['difficulty'] = difficulty.value;
      if (isCompound != null) data['is_compound'] = isCompound;
      if (equipment != null) data['equipment'] = equipment.value;
      if (description != null) data['description'] = description;

      final Map<String, dynamic> response = await exerciseService.update(data);

      final updatedExercise = Exercise.fromJson(response['data']);

      final index = exercises?.indexWhere((e) => e.id == id) ?? -1;
      if (index >= 0) {
        exercises?[index] = updatedExercise;
      }

      _applyFilters();
      exercise = updatedExercise;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 👇 Filtrage
  void _applyFilters() {
    if (exercises == null) return;

    filteredExercises = exercises!.where((exercise) {
      // Filtre par recherche
      if (searchQuery.isNotEmpty &&
          !exercise.name.toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }

      // Filtre par difficulté
      if (selectedDifficulty != null &&
          exercise.difficulty != selectedDifficulty) {
        return false;
      }

      // Filtre par équipement
      if (selectedEquipment != null &&
          exercise.equipment != selectedEquipment) {
        return false;
      }

      // Filtre par type (composé/isolation)
      if (isCompoundFilter != null && exercise.isCompound != isCompoundFilter) {
        return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    _applyFilters();
  }

  void setDifficultyFilter(Exercisedifficulty? difficulty) {
    selectedDifficulty = difficulty;
    _applyFilters();
  }

  void setEquipmentFilter(ExerciseEquipment? equipment) {
    selectedEquipment = equipment;
    _applyFilters();
  }

  void setCompoundFilter(bool? isCompound) {
    isCompoundFilter = isCompound;
    _applyFilters();
  }

  void clearFilters() {
    searchQuery = '';
    selectedDifficulty = null;
    selectedEquipment = null;
    isCompoundFilter = null;
    _applyFilters();
  }

  Future<void> logout() async {
    authStore.clearTokens();
  }
}
