class GoalsAchievedModel {
  final String date;
  final Map<String, bool?> goalsAchieved; // hanya untuk boolean goals
  final Map<String, NumericGoal> numericGoals; // numeric goals dipisah
  final int pointsEarned;
  final int totalPoints;

  GoalsAchievedModel({
    required this.date,
    required this.goalsAchieved,
    required this.numericGoals,
    required this.pointsEarned,
    required this.totalPoints,
  });

  factory GoalsAchievedModel.fromJson(Map<String, dynamic> json) {
    final rawGoals = Map<String, bool?>.from(json['goals_achieved'] ?? {});
    final rawNumericGoals = Map<String, dynamic>.from(json['numeric_goals'] ?? {});

    final numericGoals = rawNumericGoals.map((key, value) {
      return MapEntry(key, NumericGoal.fromJson(value));
    });

    return GoalsAchievedModel(
      date: json['date'] as String,
      goalsAchieved: rawGoals,
      numericGoals: numericGoals,
      pointsEarned: json['points_earned'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
    );
  }
}

class NumericGoal {
  final num? target;
  final bool? achieved;

  NumericGoal({this.target, this.achieved});

  factory NumericGoal.fromJson(Map<String, dynamic> json) {
    return NumericGoal(
      target: json['target'] as num?,
      achieved: json['achieved'] as bool?,
    );
  }
}
