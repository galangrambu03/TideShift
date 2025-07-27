import 'package:ecomagara/datasource/services/firebaseAuthServices.dart';
import 'package:ecomagara/domain/repositories/user_repostitory.dart';
import 'package:ecomagara/user_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final firebaseAuthService = Get.find<FirebaseAuthService>();
  final userController = Get.find<UserController>();
  final userRepository = Get.find<UserRepository>();

  // active user from Firebase auth
  var user = Rxn<User>();
  // loading state for async operations
  RxBool isLoading = false.obs;

  // get user data when the controller is initialized
  @override
  void onInit() {
    super.onInit();
    user.value = FirebaseAuth.instance.currentUser;
  }

  /// helper: did user already logged in?
  bool get isLoggedIn => user.value != null;

  // sign up
  // SIGN UP
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String profilePicture,
  }) async {
    try {
      isLoading.value = true;

      // 1. Sign up to Firebase Auth
      await firebaseAuthService.signUp(email, password);
      user.value = FirebaseAuth.instance.currentUser;

      // 2. Sync user to backend (username & profilePicture from frontend)
      await userController.syncUserData(username, profilePicture);
      await userController.fetchUserProfile();
      // await
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
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
