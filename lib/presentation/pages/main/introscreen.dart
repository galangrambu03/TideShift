import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/main.dart';
import 'package:ecomagara/presentation/widgets/defaultButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/decorationImages/carbonIntro.png",
      "title": "Track Your Carbon",
      "desc":
          "Track your daily carbon footprint with the carbon checklist recap and hit your carbon target!",
    },
    {
      "image": "assets/images/decorationImages/visualIslandIntro.png",
      "title": "Visual Island",
      "desc":
          "Your daily carbon footprint level represented as an island here. Take care of it or break it? Your choice is clear here.",
    },
    {
      "image": "assets/images/decorationImages/diyIntro.png",
      "title": "DIY for Earth",
      "desc":
          "Starting from home, you can help the earth. Try these eco-friendly DIY projects that are easy to make and fun to share.",
    },
    {
      "image": "assets/images/decorationImages/disasterIntro.png",
      "title": "Ready for Impact",
      "desc":
          "Be the first to be ready when disaster strikes. Learn the essential steps to deal with climate impacts, and spread your knowledge to save more lives.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(data['image']!, height: 300),
                          const SizedBox(height: 40),
                          Text(
                            data['title']!,
                            style: const TextStyle(
                              fontSize: 28,
                              color: AppColors.textDarkBlue,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            data['desc']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SmoothPageIndicator(
                controller: _pageController,
                count: onboardingData.length,
                effect: SwapEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppColors.surface,
                  dotColor: AppColors.textDarkBlue.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: defaultButton(
                  color: AppColors.button2,
                  text:
                      _currentPage == onboardingData.length - 1
                          ? "Get Started"
                          : "Next",
                  onPressed: () {
                    if (_currentPage == onboardingData.length - 1) {
                      Get.off(
                        Main(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 500),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.off(
                    Main(),
                    transition: Transition.fadeIn,
                  );
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(color: AppColors.surface),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
