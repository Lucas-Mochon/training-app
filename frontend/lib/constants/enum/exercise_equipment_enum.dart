enum ExerciseEquipment {
  barbell('barbell'),
  dumbbell('dumbbell'),
  bodyweight('bodyweight'),
  machine('machine');

  final String value;

  const ExerciseEquipment(this.value);

  static ExerciseEquipment fromString(String str) {
    return ExerciseEquipment.values.firstWhere(
      (level) => level.value == str,
      orElse: () => ExerciseEquipment.bodyweight,
    );
  }
}
