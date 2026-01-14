import 'package:frontend/constants/enum/exercise_muscle_role_enum.dart';

class ExerciseMuscle {
  final int id;
  final ExerciseMusclerole role;
  final String exerciseId;
  final int muscleGroupId;

  ExerciseMuscle({
    required this.id,
    required this.role,
    required this.exerciseId,
    required this.muscleGroupId,
  });

  factory ExerciseMuscle.fromJson(Map<String, dynamic> json) {
    return ExerciseMuscle(
      id: json['id'],
      role: ExerciseMusclerole.fromString(json['role']),
      exerciseId: json['exerciseId'],
      muscleGroupId: json['muscleGroupId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.value,
      'exerciseId': exerciseId,
      'muscleGroupId': muscleGroupId,
    };
  }
}
