import 'dart:math';

import 'package:ecomagara/datasource/models/DailyCarbonLogModel.dart';
import 'package:ecomagara/datasource/models/FuzzyModel.dart';
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
      print('RAW RESPONSE: $response');

      fuzzyResponse.value = response;
      fuzzyResponse.refresh();

      print('''RESPON FUZZY LOGIC: 
    Total carbon: ${fuzzyResponse.value!.totalCarbon}
    Carbon Level: ${fuzzyResponse.value!.carbonLevel}
    Island Path: ${fuzzyResponse.value!.islandPath}
    Emission Category: ${fuzzyResponse.value!.emissionCategory}
    Improvement Suggestions: ${fuzzyResponse.value!.improvementSuggestions}
    Fuzzy Analysis: 
      Suggestions: ${fuzzyResponse.value!.fuzzyAnalysis.suggestions}
      Potential Savings : ${fuzzyResponse.value!.fuzzyAnalysis.potentialSavings}
      Normal Values : ${fuzzyResponse.value!.fuzzyAnalysis.normalValues}
    Historical Data Points: ${fuzzyResponse.value!.historicalDataPoints}
    ''');

      // cek ulang apakah hari ini sudah submit dan ambil log terbaru
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

  // Function to calculate carbon distribution by categories (e.g Transport, food etc)
  // Note: the reduction is only affecting others variabel in the same category and cannot minus
  Map<String, double> calculateCarbonDistribution(CarbonLogModel log) {
    // transport
    double transport = (log.carTravelKm * 0.21);
    double transportReduction = (log.noDriving ? 1.0 : 0.0);
    transport = max(0, transport - transportReduction);

    // food
    double food = 0.0;
    food += (log.packagedFood ? 0.5 : 0.0);
    food += (log.wasteFood ? 0.9 : 0.0);

    double foodReduction = (log.plantMealThanMeat ? 2.0 : 0.0);
    food = max(0, food - foodReduction);

    // energy
    double energy = 0.0;
    energy += log.electronicTimeHours * 0.06;
    energy += log.showerTimeMinutes * 0.05;
    energy += (log.airConditioningHeating ? 1.5 : 0.0);

    double energyReduction = (log.saveEnergy ? 0.3 : 0.0);
    energy = max(0, energy - energyReduction);

    // lifestyle
    double lifestyle = 0.0;
    lifestyle += (log.onlineShopping ? 1.0 : 0.0);

    double lifestyleReduction = 0.0;
    lifestyleReduction += (log.useTumbler ? 0.2 : 0.0);
    lifestyleReduction += (log.separateRecycleWaste ? 0.7 : 0.0);
    lifestyle = max(0, lifestyle - lifestyleReduction);
    print('packagedFood: ${log.packagedFood}');
    print('wasteFood: ${log.wasteFood}');
    print('plantMealThanMeat: ${log.plantMealThanMeat}');

    return {
      'Transport': transport,
      'Food': food,
      'Energy': energy,
      'Lifestyle': lifestyle,
    };
  }

  void clear() {
    isLoading.value = false;
    errorMessage.value = '';
    fuzzyResponse.value = null;
    isTodaySubmited.value = false;
    todayLog.value = null;
    recentLogs.value = null;
  }
}
