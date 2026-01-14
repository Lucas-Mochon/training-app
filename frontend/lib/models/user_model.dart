import 'package:frontend/constants/enum/user_goal_enum.dart';
import 'package:frontend/constants/enum/user_level_enum.dart';

class User {
  final String id;
  final String email;
  final String passwordHash;
  final UserLevel level;
  final UserGoal goal;
  final String? refreshToken;

  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.level,
    required this.goal,
    this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      passwordHash: json['password_hash'],
      level: UserLevel.fromString(json['level']),
      goal: UserGoal.fromString(json['goal']),
      refreshToken: json['refreshToken'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password_hash': passwordHash,
      'level': level.value,
      'goal': goal.value,
      'refreshToken': refreshToken,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
