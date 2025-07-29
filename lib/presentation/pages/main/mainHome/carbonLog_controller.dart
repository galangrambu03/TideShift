import 'package:ecomagara/datasource/models/DailyCarbonLogModel.dart';
import 'package:ecomagara/datasource/models/carbonLog.dart';
import 'package:ecomagara/domain/repositories/dailyCarbonLog_repository.dart';
import 'package:get/get.dart';

class DailyCarbonLogController extends GetxController {
  final DailyCarbonLogRepository repository;

  DailyCarbonLogController({required this.repository});

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var fuzzyResponse = Rxn<FuzzyModel>();
  var isTodaySubmited = false.obs;

  var todayLog = Rxn<CarbonLogModel>();
  var recentLogs = Rxn<List<CarbonLogModel>>();

  // Submit Daily Carbon Log and calculate total, next goals etc
  Future<void> submitDailyChecklist(Map<String, dynamic> checklistData) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await repository.submitChecklist(checklistData);
      fuzzyResponse.value = response;
      print('''RESPON FUZZY LOGIC: 
      Total carbon: ${fuzzyResponse.value!.totalCarbon}
      Carbon Level: ${fuzzyResponse.value!.carbonLevel}
      Island Path: ${fuzzyResponse.value!.islandPath}
      Emission Category: ${fuzzyResponse.value!.emissionCategory}
      Improvement Suggestions: ${fuzzyResponse.value!.improvementSuggestions});
      Fuzzy Analysis: 
        Suggestions: ${fuzzyResponse.value!.fuzzyAnalysis.suggestions}
        Potential Savings : ${fuzzyResponse.value!.fuzzyAnalysis.potentialSavings}
        Normal Values : ${fuzzyResponse.value!.fuzzyAnalysis.normalValues}
        Intensity Levels : ${fuzzyResponse.value!.fuzzyAnalysis.intensityLevels}
      Historical Data Points: ${fuzzyResponse.value!.historicalDataPoints}
      ''');
      await checkTodaySubmission();
      await fetchTodayLog();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Check if today's submission is already done
  Future<void> checkTodaySubmission() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await repository.checkTodaySubmission();
      isTodaySubmited.value = response.hasSubmitted;
      print('TODAY SUBMIT INDICATOR: ${isTodaySubmited.value}');
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Check if user already submit or not
  // bool get hasSubmittedToday => todayLog.value != null;

  // Fetch today log
  Future<void> fetchTodayLog() async {
    try {
      isLoading.value = true;
      final log = await repository.getTodayLog();
      todayLog.value = log;
      print('TODAY LOG: ${todayLog.value}');
    } catch (e) {
      print('Error fetching today\'s log: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch log up to 5 months
  Future<void> fetchRecentLogs() async {
    try {
      isLoading.value = true;
      final logs = await repository.getRecentLogs();
      recentLogs.value = logs.isEmpty ? null : logs;
      print('RECENT LOGS: ${recentLogs.value}');
    } catch (e) {
      print('Error recentLogs: $e');
      recentLogs.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
