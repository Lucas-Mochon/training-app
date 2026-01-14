enum Exercisedifficulty {
  easy('easy'),
  medium('medium'),
  hard('hard');

  final String value;

  const Exercisedifficulty(this.value);

  static Exercisedifficulty fromString(String str) {
    return Exercisedifficulty.values.firstWhere(
      (level) => level.value == str,
      orElse: () => Exercisedifficulty.medium,
    );
  }
}
