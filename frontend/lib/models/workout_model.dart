import 'package:frontend/constants/enum/workout_goal_enum.dart';

class Workout {
  final String id;
  final Workoutgoal goal;
  final int duration;
  final String userId;

  final DateTime createdAt;
  final DateTime updatedAt;

  Workout({
    required this.id,
    required this.goal,
    required this.duration,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      goal: Workoutgoal.fromString(json['goal']),
      duration: json['duration'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration': duration,
      'goal': goal.value,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
