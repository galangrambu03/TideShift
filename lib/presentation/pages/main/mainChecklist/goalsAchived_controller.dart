import 'package:get/get.dart';
import 'package:ecomagara/datasource/models/goalsAchievedModel.dart';
import 'package:ecomagara/domain/repositories/goalsAchieved_repository.dart';

class GoalsAchievedController extends GetxController {
  final GoalsAchievedRepository repository;

  GoalsAchievedController({required this.repository});

  var isLoading = false.obs;
  var goalsAchieved = Rxn<GoalsAchievedModel>();
  var errorMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchGoalsAchieved();
  }

  Future<void> fetchGoalsAchieved() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await repository.getGoalsAchieved();
      goalsAchieved.value = data;

      print('=== GOALS ACHIEVED ===');
      print('Date: ${data.date}');
      data.goalsAchieved.forEach((key, value) {
        print('Boolean Goal: $key = $value');
      });
      data.numericGoals.forEach((key, value) {
        print(
          'Numeric Goal: $key target=${value.target}, achieved=${value.achieved}',
        );
      });
      print('Points earned today: ${data.pointsEarned}');
      print('Total points: ${data.totalPoints}');
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    isLoading.value = false;
    goalsAchieved.value = null;
    errorMessage.value = '';
  }
}
