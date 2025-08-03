import 'package:ecomagara/datasource/models/dailyGoalItemModel.dart';
import 'package:ecomagara/domain/repositories/dailyGoals_repository.dart';
import 'package:get/get.dart';

class DailyGoalsController extends GetxController {
  final DailyGoalsRepository repository;

  DailyGoalsController({required this.repository});

  var isLoading = false.obs;
  var goals = <DailyGoalItemModel>[].obs;
  var logDate = Rxn<DateTime>();
  var error = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchGoals();
  }

  Future<void> fetchGoals() async {
    isLoading.value = true;
    error.value = '';
    try {
      final result = await repository.getLatestGoals();
      goals.value = result.goals;

      // DEBUG PRINT ALL GOALS
      for (var goal in result.goals) {
        print(
          '📌 Goal => type: ${goal.type}, field: ${goal.field}, title: ${goal.title}, value: ${goal.value}, unit: ${goal.unit}',
        );
      }

      logDate.value = result.logDate;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    isLoading.value = false;
    goals.clear();
    logDate.value = null;
    error.value = '';
  }
}
