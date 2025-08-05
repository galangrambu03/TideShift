import 'package:ecomagara/datasource/models/goalsAchievedModel.dart';

abstract class GoalsAchievedRepository {
  Future<GoalsAchievedModel> getGoalsAchieved();
}
