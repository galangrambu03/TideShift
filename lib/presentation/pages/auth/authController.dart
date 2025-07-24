import 'package:ecomagara/datasource/services/firebaseAuthServices.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final firebaseAuthService = Get.find<FirebaseAuthService>();

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
  Future<void> signUp({required String email, required String password}) async {
    try {
      isLoading.value = true;
      firebaseAuthService.signUp(email, password);
      isLoading.value = false;
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
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    firebaseAuthService.resetPassword(email);
  }

  // Reload user data
  // Future<void> reloadUser() async {
  //   await firebaseAuthService.reloadUser();
}
