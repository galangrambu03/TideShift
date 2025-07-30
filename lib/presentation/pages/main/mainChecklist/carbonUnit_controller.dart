import 'package:ecomagara/domain/repositories/carbonUnits_repository.dart';
import 'package:get/get.dart';

class CarbonUnitController extends GetxController {
  final CarbonUnitRepository repository;

  CarbonUnitController({required this.repository});

  var humorText = ''.obs;

  Future<void> loadHumor(double totalCarbon) async {
    final label = await repository.getRandomHumorLabel(totalCarbon);
    humorText.value = label;
  }
}
