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
  RxBool isSync = false.obs; // to check if user is synced with firebase or not

  @override
  void onInit() {
    super.onInit();
    user.value = FirebaseAuth.instance.currentUser;
    if (user.value != null) {
      // pengguna masih login, bisa langsung sync
      userController
          .fetchUserProfile()
          .then((_) {
            isSync.value = true;
          })
          .catchError((_) {
            isSync.value = false;
          });
    }
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

      // 1. Sign up to Firebase auth
      await firebaseAuthService.signUp(email, password);

      // 2. Save user data to backend database
      await userController.syncUserData(username, profilePicture);

      // 3. Set current user
      user.value = FirebaseAuth.instance.currentUser;

      // 4. Fetch user data after sign up
      await userController.fetchUserProfile();
      isSync.value = true;
    } catch (e) {
      isSync.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // login
  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      isSync.value = false;

      // 1. Login to Firebase auth
      await firebaseAuthService.login(email, password);
      user.value = FirebaseAuth.instance.currentUser;

      // 2. Coba fetch user data
      await userController.fetchUserProfile();
      isSync.value = true;
    } catch (e) {
      // kalau gagal fetch user (mungkin user belum ada di DB)
      if (user.value != null) {
        final username =
            user.value!.displayName ?? user.value!.email!.split("@")[0];
        final profilePicture =
            user.value!.photoURL ?? "assets/images/profilePictures/default.png";

        await userController.syncUserData(username, profilePicture);
        await userController.fetchUserProfile();
        isSync.value = true;
      } else {
        isSync.value = false;
      }
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
    isSync.value = false;
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    firebaseAuthService.resetPassword(email);
  }

  // Reload user data
  // Future<void> reloadUser() async {
  //   await firebaseAuthService.reloadUser();
}
