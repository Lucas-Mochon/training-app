import 'package:frontend/constants/enum/exercise_difficulty_enum.dart';
import 'package:frontend/constants/enum/exercise_equipment_enum.dart';

class Exercise {
  final int id;
  final String name;
  final String? description;
  final Exercisedifficulty? difficulty;
  final bool isCompound;
  final ExerciseEquipment? equipment;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Exercise({
    required this.id,
    required this.name,
    this.description,
    this.difficulty,
    this.isCompound = false,
    this.equipment,
    this.createdAt,
    this.updatedAt,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      difficulty: json['difficulty'] != null
          ? Exercisedifficulty.fromString(json['difficulty'])
          : null,
      isCompound: json['is_compound'] ?? false,
      equipment: json['equipment'] != null
          ? ExerciseEquipment.fromString(json['equipment'])
          : null,
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
      'name': name,
      'description': description,
      'difficulty': difficulty?.value,
      'is_compound': isCompound,
      'equipment': equipment?.value,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
