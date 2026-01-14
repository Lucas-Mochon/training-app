enum UserGoal {
  strength('strength'),
  hypertrophy('hypertrophy'),
  cut('cut');

  final String value;

  const UserGoal(this.value);

  static UserGoal fromString(String str) {
    return UserGoal.values.firstWhere(
      (goal) => goal.value == str,
      orElse: () => UserGoal.strength,
    );
  }
}
