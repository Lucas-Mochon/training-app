class WorkoutExercise {
  final int id;
  final int sets;
  final String reps;
  final int restSeconds;
  final int orderIndex;
  final String workoutId;
  final String exerciseId;

  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutExercise({
    required this.id,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    required this.orderIndex,
    required this.workoutId,
    required this.exerciseId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'],
      sets: json['sets'],
      reps: json['reps'],
      restSeconds: json['restSeconds'],
      orderIndex: json['orderIndex'],
      workoutId: json['workoutId'],
      exerciseId: json['exerciseId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sets': sets,
      'reps': reps,
      'restSeconds': restSeconds,
      'orderIndex': orderIndex,
      'workoutId': workoutId,
      'exerciseId': exerciseId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
