import 'package:ecomagara/domain/repositories/user_repostitory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ecomagara/datasource/models/userModel.dart';

class UserController extends GetxController {
  final UserRepository repository = Get.find<UserRepository>();

  // User data from database
  var userData = Rxn<UserModel>();
  var isLoading = false.obs;

  // Fetch user data when the controller is initialized
  @override
  void onInit() {
    super.onInit();

    if (FirebaseAuth.instance.currentUser != null) {
      fetchUserProfile();
    }
  }
  
  /// Fetch user profile from backend (/me)
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final profile = await repository.getProfile();
      userData.value = profile;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Sync user data with Firebase
  Future<void> syncUserData(String name, String profilePic) async {
    try {
      isLoading.value = true;
      await repository.syncUser(username: name, profilePicture: profilePic);
    } catch (e) {
      Get.snackbar("Error", "Failed to sync user data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    userData.value = null; 
    isLoading.value = false;
  }
}
