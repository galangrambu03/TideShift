import 'package:ecomagara/datasource/models/disasterModel.dart';
import 'package:ecomagara/datasource/models/diyModel.dart';
import 'package:ecomagara/domain/repositories/disaster_repository.dart';
import 'package:ecomagara/domain/repositories/diy_repository.dart';
import 'package:get/get.dart';

class DisasterController extends GetxController {
  final DisasterRepository repository;

  DisasterController({required this.repository});

  var disasters = <DisasterModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDisasters();
    getDisastersPerCountry();
  }

  Future<void> fetchDisasters() async {
    try {
      isLoading.value = true;
      final projects = await repository.getDisasters();
      disasters.value = projects;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Get disasters per country of the user
  List<DisasterModel> getDisastersPerCountry() {
    return disasters
        .where((disaster) => disaster.countries.contains('Indonesia'))
        .toList();
  }
}
