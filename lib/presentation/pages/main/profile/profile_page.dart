import 'package:ecomagara/config/config.dart';
import 'package:ecomagara/datasource/remote/profile_datasource.dart';
import 'package:ecomagara/datasource/repositories/profile_impl.dart';
import 'package:ecomagara/main.dart';
import 'package:ecomagara/presentation/pages/auth/authController.dart';
import 'package:ecomagara/presentation/widgets/defaultButton.dart';
import 'package:ecomagara/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecomagara/config/colors.dart';
import 'package:intl/intl.dart';
import 'profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(
      ProfileController(
        repository: ProfileRepositoryImpl(datasource: ProfileDatasource()),
      ),
    );
    final UserController userController = Get.find();
    final AuthController authController = Get.find();

    // misal joinDate adalah DateTime
    final joinDate = userController.userData.value!.joinDate;

    // format tanggal: "dd MMMM" (contoh: 06 August)
    final formattedDate = DateFormat('MMMM yyyy').format(joinDate);

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
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Obx(() {
                  final userData = userController.userData.value;
                  final profilePic =
                      (userData?.profilePicture?.isNotEmpty ?? false)
                          ? userData!.profilePicture
                          : 'default.png';

                  return CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.black12,
                    backgroundImage: AssetImage(
                      'assets/images/profilePictures/$profilePic',
                    ),
                  );
                }),
                IconButton.filled(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: SizedBox(
                            height: 170,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    await controller.updateProfilePicture(
                                      'prof${index + 1}.png',
                                    );
                                    Get.back();
                                  },
                                  child: Obx(() {
                                    final currentPic =
                                        userController
                                            .userData
                                            .value
                                            ?.profilePicture ??
                                        '';
                                    final selected =
                                        currentPic == 'prof${index + 1}.png';

                                    return CircleAvatar(
                                      radius: 50,
                                      backgroundColor:
                                          selected ? Colors.green : null,
                                      backgroundImage: AssetImage(
                                        'assets/images/profilePictures/prof${index + 1}.png',
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.button2,
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      AppColors.surface,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // username (dinamis dengan fallback)
            Obx(() {
              final username =
                  userController.userData.value?.username?.isNotEmpty ?? false
                      ? userController.userData.value!.username
                      : 'username';
              // eco warrior text

              return Text(
                username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              );
            }),
            const SizedBox(height: 5),

            Text(
              'Eco Warrior since $formattedDate',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // points card (fallback ke 0 jika null)
            Obx(() {
              final points = userController.userData.value?.points ?? 0;

              return Container(
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
                    color: const Color(0xFF55A581),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 24),
                      const SizedBox(height: 8),
                      Text(
                        points.toString(),
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
              );
            }),
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
                  Get.dialog(
                    Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: const Text(
                                'Are you sure want to Logout ?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // tombol confirm
                                Expanded(
                                  child: defaultButton(
                                    gradient: AppColors.buttonGradient,
                                    text: 'Confirm',
                                    onPressed: () async {
                                      await authController.logout();
                                      Get.offAll(Main());
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // tombol cancel
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Get.back(),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: AppColors.button1light,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: AppColors.button1light,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            // footer app name
            Column(
              children: [
                Text(
                  '${AppConfig.appName} ${AppConfig.version}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConfig.slogan,
                  style: const TextStyle(color: Colors.black38, fontSize: 12),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
