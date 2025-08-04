import 'package:ecomagara/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecomagara/config/colors.dart';
import 'profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final UserController userController = Get.find();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // avatar
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.black12,
              child: Icon(Icons.person, size: 50, color: Colors.black54),
            ),
            const SizedBox(height: 10),

            // username (dinamis)
            Obx(
              () => Text(
                controller.username.value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 5),

            // TODO: Implemets
            const Text(
              'Eco Warrior since 2023',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // points card
            Obx(
              () => Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 15),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Color(0xFF55A581),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 24),
                      const SizedBox(height: 8),
                      Text(
                        userController.userData.value!.points.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Points Earned',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // logout button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.logout, color: Colors.black),
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Sign out of your account',
                  style: TextStyle(color: AppColors.textGrey),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.red,
                  size: 16,
                ),
                onTap: () {
                  // TODO: implemet logout
                },
              ),
            ),

            const Spacer(),

            // footer app name
            const Column(
              children: [
                Text(
                  'app_name v0.0.1',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'slogan',
                  style: TextStyle(color: Colors.black38, fontSize: 12),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
