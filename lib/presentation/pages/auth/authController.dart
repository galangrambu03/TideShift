import 'package:ecomagara/datasource/services/firebaseAuthServices.dart';
import 'package:ecomagara/domain/repositories/user_repostitory.dart';
import 'package:ecomagara/user_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final firebaseAuthService = Get.find<FirebaseAuthService>();
  final userController = Get.find<UserController>();
  final userRepository = Get.find<UserRepository>();

  var user = Rxn<User>();
  RxBool isLoading = false.obs;
  RxBool isSync = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = FirebaseAuth.instance.currentUser;
  }

  bool get isLoggedIn => user.value != null;

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String profilePicture,
  }) async {
    try {
      isLoading.value = true;
      isSync.value = false;

      // 1. Sign up ke Firebase
      await firebaseAuthService.signUp(email, password);

      // 2. Simpan data ke backend
      await userController.syncUserData(username, profilePicture);

      // 3. Set user hanya setelah backend siap
      user.value = FirebaseAuth.instance.currentUser;

      // 4. Ambil profile backend kalau perlu
      await userController.fetchUserProfile();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
      isSync.value = true;
    }
  }


  // login
  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      await firebaseAuthService.login(email, password);
      await userController.fetchUserProfile();
      user.value = FirebaseAuth.instance.currentUser;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// logout
  Future<void> signOut() async {
    await firebaseAuthService.logout();
    user.value = null;
    userController.userData.value = null;
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    firebaseAuthService.resetPassword(email);
  }

  // Reload user data
  // Future<void> reloadUser() async {
  //   await firebaseAuthService.reloadUser();
}
