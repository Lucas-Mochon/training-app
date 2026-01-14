import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/models/workout_exercise.dart';
import 'package:frontend/models/workout_model.dart';

class WorkoutDetailExerciseItem {
  final Exercise exercise;
  final WorkoutExercise workoutExercise;

  WorkoutDetailExerciseItem({
    required this.exercise,
    required this.workoutExercise,
  });

  factory WorkoutDetailExerciseItem.fromJson(Map<String, dynamic> json) {
    return WorkoutDetailExerciseItem(
      exercise: Exercise.fromJson(json),
      workoutExercise: WorkoutExercise.fromJson(json['WorkoutExercise'] ?? {}),
    );
  }
}

class WorkoutDetailResponse {
  final Workout workout;
  final List<WorkoutDetailExerciseItem> exercises;

  WorkoutDetailResponse({required this.workout, required this.exercises});

  factory WorkoutDetailResponse.fromJson(Map<String, dynamic> json) {
    var exercisesList = json['exercises'] as List? ?? [];

    return WorkoutDetailResponse(
      workout: Workout.fromJson(json),
      exercises: exercisesList
          .map<WorkoutDetailExerciseItem>(
            (ex) => WorkoutDetailExerciseItem.fromJson(ex),
          )
          .toList(),
    );
  }
}
