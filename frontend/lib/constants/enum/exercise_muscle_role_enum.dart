enum ExerciseMusclerole {
  primary('primary'),
  secondary('secondary');

  final String value;

  const ExerciseMusclerole(this.value);

  static ExerciseMusclerole fromString(String str) {
    return ExerciseMusclerole.values.firstWhere(
      (level) => level.value == str,
      orElse: () => ExerciseMusclerole.primary,
    );
  }
}
