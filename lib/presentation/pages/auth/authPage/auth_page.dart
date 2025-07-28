import 'package:ecomagara/presentation/pages/auth/SignupPage/signUp_page.dart';
import 'package:ecomagara/presentation/pages/auth/SignupPage/signUp_controller.dart';
import 'package:ecomagara/presentation/pages/auth/loginPage/login_controller.dart';
import 'package:ecomagara/presentation/pages/auth/loginPage/login_page.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      Get.put(LoginController());
      return LoginScreen(showSignUpPage: toggleScreens);
    } else {
      Get.put(SignUpController());
      return SignUpScreen(showLoginPage: toggleScreens);
    }
  }
}
