import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/presentation/pages/auth/authController.dart';
import 'package:ecomagara/presentation/pages/auth/loginPage/login_controller.dart';
import 'package:ecomagara/presentation/pages/main/offlineHome/homepageOffline.dart';
import 'package:ecomagara/presentation/widgets/defaultButton.dart';
import 'package:ecomagara/presentation/widgets/myTextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback showSignUpPage;
  LoginScreen({super.key, required this.showSignUpPage});

  LoginController get logincontroller => Get.find<LoginController>();
  AuthController get authController => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // background hijau muda
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/images/decorationImages/appIcon.png'),
              const SizedBox(height: 24),

              // Tab Login/Sign Up
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradient,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: AppColors.surface,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        onTap: () {
                          showSignUpPage();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.button1dark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Email
              myTextField(
                hintText: 'Email',
                controller: logincontroller.emailController,
              ),
              const SizedBox(height: 12),

              // Password
              Obx(
                () => myTextField(
                  hintText: 'Password',
                  controller: logincontroller.passwordController,
                  obscureText: logincontroller.obscurePassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      logincontroller.obscurePassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      logincontroller.togglePasswordVisibility();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    showResetPasswordPopup();
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Login Button
              defaultButton(
                text:
                    authController.isLoading.value ? 'Logging in...' : 'Login',
                onPressed: () async {
                  if (logincontroller.emailController.text.isEmpty ||
                      logincontroller.passwordController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please fill in all fields',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    try {
                      await authController.login(
                        email: logincontroller.emailController.text,
                        password: logincontroller.passwordController.text,
                      );
                      print('Login successful');
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Failed to log in: ${e.toString()}',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  }
                },
                gradient: AppColors.buttonGradient,
              ),

              const SizedBox(height: 32),

              // Offline Mode
              const Text(
                "Don’t have an internet?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Offline Button
              defaultButton(
                text: 'Offline Mode',
                onPressed: () {
                  Get.to(OfflineHomepage());
                },
                gradient: AppColors.buttonGradient,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show reset password popup
  void showResetPasswordPopup() {
    TextEditingController emailController = TextEditingController();
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFFEAF5F1), // warna latar belakang popup
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDarkBlue,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your email and we will send a link to reset your password to your email.',
                  style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                myTextField(hintText: 'Email', controller: emailController),
                const SizedBox(height: 20),
                defaultButton(
                  text: '✉️ Send Reset Link',
                  onPressed: () {
                    if (emailController.text.isNotEmpty) {
                     authController.resetPassword(
                        email: emailController.text,
                      ).then((_) {
                        Get.back(); 
                        Get.snackbar(
                          'Success',
                          'Reset link sent to ${emailController.text}, if the email is not shown, please check your spam folder.',
                          duration: const Duration(seconds: 5),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }).catchError((error) {
                        Get.snackbar(
                          'Error',
                          error.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      });
                    }
                  },
                  gradient: AppColors.buttonGradient,
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Get.back(); // tutup dialog
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.button1dark),
                    foregroundColor: AppColors.button1dark,
                    minimumSize: const Size.fromHeight(45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
