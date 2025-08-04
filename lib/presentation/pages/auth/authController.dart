import 'package:ecomagara/datasource/services/firebaseAuthServices.dart';
import 'package:ecomagara/domain/repositories/user_repostitory.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/carbonUnit_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/checklist_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/dailyGoals_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/carbonLog_controller.dart';
import 'package:ecomagara/user_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final firebaseAuthService = Get.find<FirebaseAuthService>();
  final userController = Get.find<UserController>();
  final userRepository = Get.find<UserRepository>();

  var user = Rxn<User>();
  RxBool isLoading = false.obs;
  RxBool isSync = false.obs; // untuk cek sudah sinkron user data atau belum

  @override
  void onInit() {
    super.onInit();
    user.value = FirebaseAuth.instance.currentUser;
    if (user.value != null) {
      // kalau sudah login, langsung fetch data user dan lainnya
      reloadUserData();
    }
  }

  bool get isLoggedIn => user.value != null;

  /// reload semua data user dan controller lain setelah login atau app start
  Future<void> reloadUserData() async {
    try {
      isLoading.value = true;
      await userController.fetchUserProfile();

      // misal ada controller lain yang perlu fetch data user spesifik
      await Get.find<DailyGoalsController>().fetchGoals();
      await Get.find<DailyCarbonLogController>().fetchTodayLog();
      await Get.find<DailyCarbonLogController>().fetchRecentLogs();
      await Get.find<ChecklistController>().fetchChecklistStatus();

      // tambah fetch untuk controller lain jika perlu...

      isSync.value = true;
    } catch (e) {
      isSync.value = false;
      print("reloadUserData error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String profilePicture,
  }) async {
    try {
      isLoading.value = true;
      isSync.value = false;

      // 1. daftar ke Firebase auth
      await firebaseAuthService.signUp(email, password);

      // 2. simpan user data ke backend
      await userController.syncUserData(username, profilePicture);

      // 3. set current user
      user.value = FirebaseAuth.instance.currentUser;

      // 4. fetch ulang data user
      await reloadUserData();
    } catch (e) {
      isSync.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      isSync.value = false;

      // login ke Firebase
      await firebaseAuthService.login(email, password);
      user.value = FirebaseAuth.instance.currentUser;

      // fetch ulang data user dan lainnya
      await reloadUserData();
    } catch (e) {
      // kalau gagal fetch user (misal user belum ada di DB)
      if (user.value != null) {
        final username =
            user.value!.displayName ?? user.value!.email!.split("@")[0];
        final profilePicture =
            user.value!.photoURL ?? "assets/images/profilePictures/default.png";

        await userController.syncUserData(username, profilePicture);
        await reloadUserData();
        isSync.value = true;
      } else {
        isSync.value = false;
      }
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await firebaseAuthService.logout();
      user.value = null;

      userController.clear();
      Get.find<ChecklistController>().reset();
      Get.find<CarbonUnitController>().clear();
      Get.find<DailyGoalsController>().clear();
      Get.find<DailyCarbonLogController>().clear();

      isSync.value = false;
    } catch (e) {
      print("Logout error: $e");
    }
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuthService.resetPassword(email);
  }
}
