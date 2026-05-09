enum PasswordStrengthLevel { weak, fair, good, strong }

class PasswordStrength {
  const PasswordStrength({
    required this.score,
    required this.level,
    required this.criteriaResults,
  });

  final int score;
  final PasswordStrengthLevel level;
  final Map<String, bool> criteriaResults;
}
