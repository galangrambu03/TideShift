import 'dart:async';

import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/main.dart';
import 'package:ecomagara/presentation/pages/auth/authController.dart';
import 'package:ecomagara/presentation/pages/main/splashscreen/splashcreen_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final SplashcreenController splashcreenController = Get.find<SplashcreenController>();
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final start = DateTime.now();

    if (authController.isLoggedIn) {
      try {
        await authController.userController.fetchUserProfile();
        authController.isSync.value = true;
      } catch (e) {
        authController.isSync.value = false;
      }
    }

    // Hitung sisa waktu agar minimal 5 detik
    final elapsed = DateTime.now().difference(start);
    final remaining = Duration(seconds: 5) - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    // Pindah ke halaman utama (Main akan handle isi user kosong / tidak)
    Get.offAll(() => Main());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/decorationImages/splashScreen.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content (center)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/decorationImages/appIconWhite.png',
                  scale: 1.2,
                ),
                const SizedBox(height: 10),
                LoadingAnimationWidget.progressiveDots(
                  color: AppColors.surface,
                  size: 30,
                ),
              ],
            ),
          ),
          // Bottom text
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/decorationImages/mascotHappy.png',
                  scale: 17,
                ),
                const SizedBox(height: 5),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      splashcreenController.fact.value.content,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
