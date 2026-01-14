class WorkoutExercise {
  final int id;
  final int? sets;
  final String? reps;
  final int? restSeconds;
  final int? orderIndex;
  final String workoutId;
  final int exerciseId;

  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutExercise({
    required this.id,
    this.sets,
    this.reps,
    this.restSeconds,
    this.orderIndex,
    required this.workoutId,
    required this.exerciseId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'] ?? 0,
      sets: json['sets'],
      reps: json['reps'],
      restSeconds: json['rest_seconds'],
      orderIndex: json['order_index'],
      workoutId: json['workoutId'] ?? '',
      exerciseId: json['exerciseId'] ?? 0,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sets': sets,
      'reps': reps,
      'rest_seconds': restSeconds,
      'order_index': orderIndex,
      'workoutId': workoutId,
      'exerciseId': exerciseId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
