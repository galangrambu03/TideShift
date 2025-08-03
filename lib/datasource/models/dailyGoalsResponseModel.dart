import 'dailyGoalItemModel.dart';

class DailyGoalsResponseModel {
  final List<DailyGoalItemModel> goals;
  final DateTime? logDate;

  DailyGoalsResponseModel({
    required this.goals,
    required this.logDate,
  });

  factory DailyGoalsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawGoals = json['goals'] as List<dynamic>;
    final parsedGoals = rawGoals
        .map((e) => DailyGoalItemModel.fromJson(e))
        .toList();

    final logDateString = json['logDate'];
    final logDate = logDateString != null ? DateTime.parse(logDateString) : null;

    return DailyGoalsResponseModel(
      goals: parsedGoals,
      logDate: logDate,
    );
  }
}
