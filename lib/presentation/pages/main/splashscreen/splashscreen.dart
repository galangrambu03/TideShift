import 'dart:async';

import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/main.dart';
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

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Get.off(
        Main(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background image
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
          // main content (center)
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
          // bottom text
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
                  () => Text(
                    splashcreenController.fact.value.content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
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
