import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/presentation/pages/main/mainDiy/offline_diy.dart';
import 'package:ecomagara/presentation/widgets/itemCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'diy_controller.dart';

class OfflineDiyPage extends StatelessWidget {
  OfflineDiyPage({super.key});
  
  final DiyController controller = Get.find<DiyController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // background gradient
        Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'DIY For Island',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.isNotEmpty) {
              return Center(
                child: Text('Error: ${controller.errorMessage.value}'),
              );
            }

            final diyItems = controller.diyProjects;

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: diyItems.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // header image
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Image.asset(
                          'assets/images/decorationImages/diyHeader.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  );
                } else {
                  final item = diyItems[index - 1];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ItemCard(
                      imagePath:
                          item.image, 
                      title: item.title,
                      description:
                          item.description,
                      buttonText: 'Craft Item',
                      onPressed: () {
                        Get.to(OfflineDiyDetailPage(diy: item));
                      },
                    ),
                  );
                }
              },
            );
          }),
        ),
      ],
    );
  }
}
