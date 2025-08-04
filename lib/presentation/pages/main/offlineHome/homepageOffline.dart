import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/main.dart';
import 'package:ecomagara/presentation/pages/main/mainDisaster/offlineDisaster_page.dart';
import 'package:ecomagara/presentation/pages/main/mainDiy/offlineDiy_page.dart';
import 'package:ecomagara/presentation/widgets/defaultButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OfflineHomepage extends StatelessWidget {
  const OfflineHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Hello, you are in\noffline mode',
                style: TextStyle(fontSize: 22, color: AppColors.textDarkBlue),
              ),
              const SizedBox(height: 4),
              const Text(
                'Login or connect to internet to open full mode',
                style: TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
              const SizedBox(height: 20),

              // Login Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/decorationImages/mascotHappy.png',
                          height: 80,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Login to start monitor your daily carbon emission!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                  height: 35,
                                  width: 130,
                                  child: defaultButton(
                                    text: 'Login',
                                    onPressed: () {
                                      // Navigate to login page
                                      Get.offAll(Main());
                                    },
                                    color: AppColors.button2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Offline Features',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              // DIY for Earth Card
              OfflineFeatureCard(
                imagePath: 'assets/images/decorationImages/diyHeader.png',
                title: 'DIY for Earth',
                onPressed: () {
                  Get.to(OfflineDiyPage());
                },
              ),
              const SizedBox(height: 15),

              // Ready for Impact Card
              OfflineFeatureCard(
                imagePath: 'assets/images/decorationImages/disasterHeader.png',
                title: 'Ready for Impact',
                onPressed: () {
                  Get.to(OfflineDisasterPage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OfflineFeatureCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onPressed;

  const OfflineFeatureCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // background image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),

          // content
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textDarkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 35,
                  width: 130,
                  child: defaultButton(
                    text: 'Open',
                    onPressed: onPressed,
                    color: AppColors.button2,
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
