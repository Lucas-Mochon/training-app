class SessionSet {
  final int id;
  final int setNumber;
  final int reps;
  final double weight;
  final String trainingSessionId;
  final int exerciseId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  SessionSet({
    required this.id,
    required this.setNumber,
    required this.reps,
    required this.weight,
    required this.trainingSessionId,
    required this.exerciseId,
    this.createdAt,
    this.updatedAt,
  });

  factory SessionSet.fromJson(Map<String, dynamic> json) {
    return SessionSet(
      id: json['id'],
      setNumber: json['set_number'],
      reps: json['reps'],
      weight: (json['weight'] as num).toDouble(),
      trainingSessionId: json['trainingSessionId'],
      exerciseId: json['exerciseId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'set_number': setNumber,
      'reps': reps,
      'weight': weight,
      'trainingSessionId': trainingSessionId,
      'exerciseId': exerciseId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
