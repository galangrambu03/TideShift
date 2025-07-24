import 'package:ecomagara/datasource/services/firebaseAuthServices.dart';
import 'package:ecomagara/presentation/pages/auth/SignupPage/signUp_controller.dart';
import 'package:ecomagara/presentation/pages/auth/authController.dart';
import 'package:ecomagara/presentation/pages/auth/authPage/auth_page.dart';
import 'package:ecomagara/presentation/pages/auth/loginPage/login_controller.dart';
import 'package:ecomagara/presentation/pages/main/introscreen.dart';
import 'package:ecomagara/presentation/pages/main/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // AUTENTICATION - Controllers initialization 
  Get.lazyPut(() => FirebaseAuthService(), fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => LoginController() , fenix: true);
  Get.lazyPut(() => SignUpController(), fenix: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Splashscreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen),
      ),
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthController>();
    // Menggunakan Obx untuk mendeteksi perubahan pada user
    // Jika user sudah login, tampilkan MainPage, jika belum tampilkan AuthPage
    return Obx(() {
      if (user.user.value != null) {
        return MainPage();
      } else {
        return AuthPage();
      }
    });
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  AuthController get authController => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              try {
                authController.signOut();
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to log out: $e',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
        ],
      ),
      body: Center(child: Text('Welcome to the Main Page!')),
    );
  }
}
