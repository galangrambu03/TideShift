import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/datasource/models/disasterModel.dart';
import 'package:ecomagara/presentation/pages/main/mainDisaster/disasterDetail_page.dart';
import 'package:ecomagara/presentation/pages/main/mainDisaster/disaster_controller.dart';
import 'package:ecomagara/presentation/widgets/itemCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfflineDisasterPage extends StatefulWidget {
  const OfflineDisasterPage({super.key});

  @override
  State<OfflineDisasterPage> createState() => _OfflineDisasterPageState();
}

class _OfflineDisasterPageState extends State<OfflineDisasterPage> {
  final DisasterController controller = Get.find<DisasterController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // background gradient
        Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),

        // scaffold
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Ready For Impact',
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

            final List<DisasterModel> disasters = controller.disasters;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                // header image
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    'assets/images/decorationImages/disasterHeader.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 15),

                // list disaster
                ...disasters.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ItemCard(
                        imagePath: item.image,
                        title: item.disasterNames,
                        description: item.description,
                        buttonText: 'Open Tips',
                        onPressed: () {
                          Get.to(DisasterDetailPage(disaster: item));
                        },
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          }),
        ),
      ],
    );
  }
}
