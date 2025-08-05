class GoalsAchievedModel {
  final String date;
  final Map<String, bool?> goalsAchieved;  // nullable bool
  final Map<String, num?> numericGoals;
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
    return GoalsAchievedModel(
      date: json['date'] as String,
      goalsAchieved: Map<String, bool?>.from(json['goals_achieved'] ?? {}),
      numericGoals: Map<String, num?>.from(json['numeric_goals'] ?? {}),
      pointsEarned: json['points_earned'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
    );
  }
}
