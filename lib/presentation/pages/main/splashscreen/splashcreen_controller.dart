import 'package:ecomagara/datasource/models/factModel.dart';
import 'package:ecomagara/domain/repositories/fact_repository.dart';
import 'package:get/get.dart';

class SplashcreenController extends GetxController {
  final factRepository = Get.find<FactRepository>();
  var fact = FactModel(id: 0, content: 'Unique facts display here').obs;

  // Fetch a random fact when the controller is initialized
  @override
  void onInit() {
    super.onInit();
    getRandomFact();
  }

  Future<void> getRandomFact() async {
    fact.value = await factRepository.getRandomFact();
  }
}
