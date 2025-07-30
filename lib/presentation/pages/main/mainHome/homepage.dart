import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/main.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/checklist_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/calendar_widget.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/carbonLog_controller.dart';
import 'package:ecomagara/presentation/pages/main/pointShop/shop_page.dart';
import 'package:ecomagara/presentation/pages/main/profile/profile_page.dart';
import 'package:ecomagara/presentation/widgets/defaultButton.dart';
import 'package:ecomagara/presentation/widgets/goalCard.dart';
import 'package:ecomagara/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final ChecklistController checklistController =
      Get.find<ChecklistController>();
  final DailyCarbonLogController carbonLogController = Get.find();

  Homepage({super.key});

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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          Obx(
                            () => Text(
                              userController.userData.value?.username ??
                                  'Loading...',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
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
                                Obx(
                                  () => Text(
                                    userController.userData.value?.points
                                            .toString() ??
                                        '---',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Get.to(ShopPage());
                            },
                          ),
                          const SizedBox(width: 12),
                          Obx(
                            () => GestureDetector(
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/profilePictures/${userController.userData.value!.profilePicture}',
                                ),
                              ),
                              onTap: () {
                                Get.to(ProfilePage());
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Recap Carbon Container
                  Obx(() {
                    final submitted = carbonLogController.isTodaySubmited.value;
                    final todayLog = carbonLogController.todayLog.value;

                    return submitted && todayLog != null
                        ? recapContainer()
                        : notRecapContainer();
                  }),

                  const SizedBox(height: 24),

                  // Today Goals
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Next Goals',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Goals that you need try to achieve for the next recap!",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: const [
                  GoalCard(
                    text: 'Traveling by bicycle, walk or public transportation',
                    showCarbonSaved: true,
                    carbonSaved: '4',
                    color: AppColors.surface,
                    textColor: Colors.black87,
                  ),
                  GoalCard(
                    text: 'Limit your showers time to 30 minutes today',
                    showCarbonSaved: true,
                    carbonSaved: '0.7',
                    color: AppColors.surface,
                    textColor: Colors.black87,
                  ),
                  GoalCard(
                    text: 'Limit your car travel to 10 km today',
                    showCarbonSaved: true,
                    carbonSaved: '5',
                    color: AppColors.surface,
                    textColor: Colors.black87,
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
    final NavigationController navController = Get.find<NavigationController>();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/decorationImages/mascotSad.png',
            height: 90,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "You haven't recapped your carbon yet today",
                  style: TextStyle(
                    color: AppColors.surface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: 35,
                    width: 130,
                    child: defaultButton(
                      text: 'Recap Carbon',
                      onPressed: () {
                        navController.indexHalaman.value = 1;
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
    );
  }

  // Widget if user have recap carbon
  Widget recapContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Your island today!",
                style: TextStyle(
                  color: AppColors.surface,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Image.asset(
                'assets/images/decorationImages/mascotHappy.png',
                height: 90,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Image.asset(
              'assets/images/islandsImages/island${carbonLogController.todayLog.value!.islandPath}.png',
              scale: 2,
            ),
          ),
        ],
      ),
    );
  }
}
