enum Workoutgoal {
  strength('strength'),
  hypertrophy('hypertrophy'),
  cut('cut');

  final String value;

  const Workoutgoal(this.value);

  static Workoutgoal fromString(String str) {
    return Workoutgoal.values.firstWhere(
      (level) => level.value == str,
      orElse: () => Workoutgoal.hypertrophy,
    );
  }
}
