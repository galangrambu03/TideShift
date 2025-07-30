import 'package:ecomagara/datasource/models/DailyCarbonLogModel.dart';
import 'package:ecomagara/datasource/models/FuzzyModel.dart';
import 'package:ecomagara/datasource/models/checkSubmission.dart';

abstract class DailyCarbonLogRepository {
  Future<FuzzyModel> submitChecklist(Map<String, dynamic> payload);
  Future<CheckSubmissionResult> checkTodaySubmission();
  Future<CarbonLogModel?> getTodayLog();
  Future<List<CarbonLogModel>> getRecentLogs();
}
