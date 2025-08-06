import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/presentation/pages/main/profile/profile_controller.dart';
import 'package:ecomagara/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final userController = Get.find<UserController>();
  final profileController = Get.find<ProfileController>();
  late final PageController pageController;

  final List<Map<String, dynamic>> islands = [
    {
      "name": "Karimun Island",
      "image": "island00",
      "description":
          "Karimun Island is a peaceful remote island with white sandy beaches, clear blue water, and a variety of tropical trees. One of its most iconic features is a tall cliff that offers stunning views of the ocean, making it perfect for nature lovers and adventure seekers!",
      "points": null,
    },
    {
      "name": "Mentawai Island",
      "image": "island10",
      "description":
          "Mentawai Island is famous for its powerful waves and beautiful surf spots, attracting surfers from around the world. Surrounded by lush rainforest and deep blue sea, the island is a perfect blend of adventure and natural beauty.",
      "points": 150,
    },
    {
      "name": "Seribu Island",
      "image": "island20",
      "description":
          "Seribu Island, located near Jakarta, Indonesia, is a tropical escape with crystal-clear waters and calm beaches. It’s an ideal place for quick getaways, but this island is in danger of sea level rise! would you save it or destroy it?",
      "points": 250,
    },
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Points Shop",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 4),
              Obx(() {
                final user = userController.userData.value;
                return Text(
                  "${user?.points ?? 0}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: islands.length,
        itemBuilder: (context, index) {
          return Center(child: _buildIslandCard(islands[index], index));
        },
      ),
    );
  }

  Widget _buildIslandCard(Map<String, dynamic> island, int index) {
    return Obx(() {
      final user = userController.userData.value;
      final bool canBuy =
          user != null && user.points >= (island['points'] ?? 0);
      final bool equipped = user?.currentIslandTheme == index;

      return Container(
        height: 480,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              island['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.blue.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/islandsImages/${island['image']}.png',
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Text(
                island['description'],
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),

            if (island['points'] != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    "${island['points']} Points",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 16),
            GestureDetector(
              onTap:
                  (!canBuy || equipped)
                      ? null
                      : () async {
                        await profileController.updateCurrentIslandTheme(index);
                        await userController.fetchUserProfile();
                      },
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient:
                      (canBuy && !equipped) ? AppColors.buttonGradient : null,
                  color: (!canBuy || equipped) ? Colors.grey[400] : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  equipped
                      ? "Equipped"
                      : canBuy
                      ? "Equip"
                      : "Not Enough Points",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
