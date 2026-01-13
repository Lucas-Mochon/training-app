class TrainingSession {
  final String id;
  final DateTime performedAt;
  final int duration;
  final int feeling;
  final String workoutId;
  final String userId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  TrainingSession({
    required this.id,
    required this.performedAt,
    required this.duration,
    required this.feeling,
    required this.workoutId,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession(
      id: json['id'],
      performedAt: json['performed_at'] != null
          ? DateTime.parse(json['performed_at'])
          : DateTime.now(),
      duration: json['duration'],
      feeling: json['feeling'],
      workoutId: json['workoutId'],
      userId: json['userId'],
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
      'performed_at': performedAt.toIso8601String(),
      'duration': duration,
      'feeling': feeling,
      'workoutId': workoutId,
      'userId': userId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
