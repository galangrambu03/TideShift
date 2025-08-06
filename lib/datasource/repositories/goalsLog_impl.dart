import 'package:ecomagara/datasource/models/dailyGoalsResponseModel.dart';
import 'package:ecomagara/datasource/remote/dailyGoalsLog_datasource.dart';
import 'package:ecomagara/domain/repositories/dailyGoals_repository.dart';

class DailyGoalsRepositoryImpl implements DailyGoalsRepository {
  final DailyGoalsRemoteDataSource remoteDataSource;

  DailyGoalsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DailyGoalsResponseModel> getLatestGoals() {
    return remoteDataSource.fetchLatestGoals();
  }
}
