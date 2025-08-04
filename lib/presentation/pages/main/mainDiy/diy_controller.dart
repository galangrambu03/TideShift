import 'package:ecomagara/datasource/models/diyModel.dart';
import 'package:ecomagara/domain/repositories/diy_repository.dart';
import 'package:get/get.dart';

class DiyController extends GetxController {
  final DiyRepository repository;

  DiyController({required this.repository});

  var diyProjects = <DiyModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDiyProjects();
  }

  Future<void> fetchDiyProjects() async {
    try {
      isLoading.value = true;
      final projects = await repository.getDiyProjects();
      diyProjects.value = projects;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
