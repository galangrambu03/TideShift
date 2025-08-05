import 'package:ecomagara/datasource/models/goalsAchievedModel.dart';
import 'package:ecomagara/datasource/remote/checkGoalsAchieved_remote.dart';
import 'package:ecomagara/domain/repositories/goalsAchieved_repository.dart';

class GoalsAchievedRepositoryImpl implements GoalsAchievedRepository {
  final GoalsAchievedRemoteDatasource remoteDatasource;

  GoalsAchievedRepositoryImpl({required this.remoteDatasource});

  @override
  Future<GoalsAchievedModel> getGoalsAchieved() {
    return remoteDatasource.fetchGoalsAchieved();
  }
}
