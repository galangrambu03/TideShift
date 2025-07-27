import 'package:ecomagara/presentation/pages/auth/SignupPage/signUp_controller.dart';
import 'package:ecomagara/presentation/pages/auth/authController.dart';
import 'package:ecomagara/presentation/pages/main/introscreen.dart';
import 'package:ecomagara/presentation/widgets/defaultButton.dart';
import 'package:ecomagara/presentation/widgets/myTextfield.dart';
import 'package:flutter/material.dart';
import 'package:ecomagara/config/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SignUpScreen extends StatelessWidget {
  final VoidCallback showLoginPage;
  SignUpScreen({super.key, required this.showLoginPage});

  SignUpController get signUpController => Get.find<SignUpController>();
  AuthController get authController => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // warna latar belakang keseluruhan
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32),
              // logo
              Image.asset('assets/images/decorationImages/appIcon.png'),
              const SizedBox(height: 24),

              // tab login/signup
              // Tab Login/Sign Up
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: AppColors.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        onTap: () {
                          showLoginPage();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Login',
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
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradient,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // form fields
              myTextField(
                hintText: 'Username',
                controller: signUpController.usernameController,
              ),
              const SizedBox(height: 12),
              myTextField(
                hintText: 'Email',
                controller: signUpController.emailController,
              ),
              const SizedBox(height: 12),
              Obx(
                () => myTextField(
                  hintText: 'Password',
                  controller: signUpController.passwordController,
                  obscureText: signUpController.obscurePassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      signUpController.obscurePassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textGrey,
                    ),
                    onPressed: () {
                      signUpController.obscurePassword.toggle();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => myTextField(
                  hintText: 'Confirm Password',
                  controller: signUpController.confirmPasswordController,
                  obscureText: signUpController.obscureConfirmPassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      signUpController.obscureConfirmPassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textGrey,
                    ),
                    onPressed: () {
                      signUpController.toggleConfirmPasswordVisibility();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 43),

              // button sign up
              Obx(
                () => defaultButton(
                  text:
                      authController.isLoading.value
                          ? 'Signing Up...'
                          : 'Sign Up',
                  gradient: AppColors.buttonGradient,
                  onPressed: () async {
                    if (signUpController.usernameController.text.isEmpty ||
                        signUpController.emailController.text.isEmpty ||
                        signUpController.passwordController.text.isEmpty ||
                        signUpController
                            .confirmPasswordController
                            .text
                            .isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please fill all fields',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else if (signUpController.passwordController.text !=
                        signUpController.confirmPasswordController.text) {
                      Get.snackbar(
                        'Error',
                        'Passwords do not match',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      try {
                        await authController.signUp(
                          email: signUpController.emailController.text,
                          password: signUpController.passwordController.text,
                          username: signUpController.usernameController.text,
                          profilePicture: 'default.png'
                        );
                        print('Sign up successful');
                        Get.offAll(IntroScreen());
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Failed to sign up: $e',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
