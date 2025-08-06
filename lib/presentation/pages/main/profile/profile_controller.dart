import 'package:ecomagara/domain/profile_repository.dart';
import 'package:ecomagara/user_controller.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileRepository repository;
  final UserController userController = Get.find();
  ProfileController({required this.repository});

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  // var user = Rxn<UserModel>();

  // Future<void> fetchUser() async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //     user.value = await repository.fetchUser();
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> updateProfilePicture(String newImageUrl) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await repository.updateProfilePicture(newImageUrl);
      await userController.fetchUserProfile(); // refetch user after update
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCurrentIslandTheme(int newTheme) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await repository.updateCurrentIslandTheme(newTheme);
      await userController.fetchUserProfile(); // refetch user after update
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
