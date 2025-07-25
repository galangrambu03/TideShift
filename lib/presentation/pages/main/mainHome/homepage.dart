import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/calendar_widget.dart';
import 'package:ecomagara/presentation/pages/main/pointShop/shop_page.dart';
import 'package:ecomagara/presentation/pages/main/profile/profile_page.dart';
import 'package:ecomagara/presentation/widgets/defaultButton.dart';
import 'package:ecomagara/presentation/widgets/goalCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Let's save our planet, every change matter!",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 4),
                                const Text(
                                  '290',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onTap: () {
                              Get.to(ShopPage());
                            },
                          ),
                          const SizedBox(width: 12),
                          // TODO: Implement user profile picture
                          GestureDetector(
                            child: Icon(
                              Icons.account_circle,
                              size: 40,
                              color: AppColors.primary,
                            ),
                            onTap: () {
                              Get.to(ProfilePage());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Recap Carbon Container
                  // TODO: Implement dynamic recap container based on user already recap or not
                  notRecapContainer(),
                  const SizedBox(height: 24),

                  // Today Goals
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.primary),
                      SizedBox(width: 8),
                      // TODO: Implement dynamic title based on day (Today goals/ Tomorrow goals)
                      Text(
                        'Today Goals',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Goals Cards
            // TODO: Implement dynamic goals by AI
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GoalCard(
                    text: 'Traveling by bicycle, walk or public transportation',
                    showCarbonSaved: true,
                    carbonSaved: '4',
                    color: AppColors.surface,
                    // ignore: deprecated_member_use
                    textColor: Colors.black.withOpacity(0.8),
                  ),
                  GoalCard(
                    text: 'Limit your showers time to 30 minutes today',
                    showCarbonSaved: true,
                    carbonSaved: '0.7',
                    color: AppColors.surface,
                    // ignore: deprecated_member_use
                    textColor: Colors.black.withOpacity(0.8),
                  ),
                  GoalCard(
                    text: 'Limit your car travel to 10 km today',
                    showCarbonSaved: true,
                    carbonSaved: '5',
                    color: AppColors.surface,
                    // ignore: deprecated_member_use
                    textColor: Colors.black.withOpacity(0.8),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            KalenderBergambar(),
          ],
        ),
      ),
    );
  }

  // Widget if user not recap carbon yet
  Widget notRecapContainer() {
    return // Box recap carbon
    Container(
      padding: const EdgeInsets.all(12),
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
                'assets/images/decorationImages/mascotSad.png',
                height: 90,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'You’ve not recap your carbon yet today',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        height: 35,
                        width: 130,
                        child: defaultButton(
                          text: 'Recap Carbon',
                          onPressed: () {
                            // TODO: Navigate to recap carbon page
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
    );
  }

  // TODO: Build widget if user already recap carbon
}
