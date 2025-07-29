import 'package:ecomagara/datasource/models/DailyCarbonLogModel.dart';
import 'package:ecomagara/datasource/models/carbonLog.dart';
import 'package:ecomagara/datasource/models/checkSubmission.dart';
import 'package:ecomagara/datasource/remote/dailyCarbonLog_remote.dart';
import 'package:ecomagara/domain/repositories/dailyCarbonLog_repository.dart';

class DailyCarbonLogRepositoryImpl implements DailyCarbonLogRepository {
  final DailyCarbonLogRemoteDataSource remoteDataSource;

  DailyCarbonLogRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FuzzyModel> submitChecklist(Map<String, dynamic> payload) {
    return remoteDataSource.submitChecklist(payload);
  }

  @override
  Future<CheckSubmissionResult> checkTodaySubmission() {
    return remoteDataSource.checkTodaySubmission();
  }

 @override
  Future<CarbonLogModel?> getTodayLog() {
    return remoteDataSource.getTodayLog();
  }

  @override
  Future<List<CarbonLogModel>> getRecentLogs() {
    return remoteDataSource.getRecentLogs();
  }
}
