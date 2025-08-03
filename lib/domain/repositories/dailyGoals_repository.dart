import 'package:ecomagara/datasource/models/dailyGoalsResponseModel.dart';

abstract class DailyGoalsRepository {
  Future<DailyGoalsResponseModel> getLatestGoals();
}
