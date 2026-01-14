enum UserLevel {
  beginner('beginner'),
  intermediate('intermediate'),
  advanced('advanced');

  final String value;

  const UserLevel(this.value);

  static UserLevel fromString(String str) {
    return UserLevel.values.firstWhere(
      (level) => level.value == str,
      orElse: () => UserLevel.beginner,
    );
  }
}
