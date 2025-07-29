import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/datasource/models/ChecklistItemModel.dart';
import 'package:ecomagara/functions/getCarbonColor_switch.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/carbonLog_controller.dart';
import 'package:ecomagara/presentation/widgets/defaultButton.dart';
import 'package:ecomagara/presentation/widgets/goalCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'checklist_controller.dart';

class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final controller = Get.put(ChecklistController());
  final DailyCarbonLogController carbonLogController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Carbon Checklist',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: Obx(() {
        // Jika sudah submit hari ini
        if (controller.isTodaySubmited.value) {
          return recapScreen();
        }
        // If not submit yet
        return checklistScreen();
      }),
    );
  }

  Widget checklistItem(String label, RxBool value, String iconName) {
    return Obx(
      () => Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(getIconByName(iconName), color: AppColors.navbarIcon),
            SizedBox(width: 12),
            Expanded(child: Text(label)),
            Checkbox(
              value: value.value,
              onChanged: (val) => value.value = val!,
              activeColor: AppColors.button1dark,
              checkColor: AppColors.surface,
            ),
          ],
        ),
      ),
    );
  }

  Widget numericInput(String label, Rx value, String iconName) {
    return Obx(
      () => Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(getIconByName(iconName), color: AppColors.navbarIcon),
            SizedBox(width: 12),
            Expanded(child: Text(label)),
            SizedBox(
              width: 60,
              child: TextFormField(
                initialValue: value.value.toString(),
                onChanged: (val) {
                  if (value is RxDouble) {
                    value.value = double.tryParse(val) ?? 0.0;
                  } else if (value is RxInt) {
                    value.value = int.tryParse(val) ?? 0;
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  hintStyle: TextStyle(color: AppColors.navbarIcon),
                  fillColor: AppColors.background,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getIconByName(String? name) {
    switch (name) {
      case 'emoji_food_beverage':
        return Icons.emoji_food_beverage;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'delete':
        return Icons.delete;
      case 'autorenew':
        return Icons.autorenew;
      case 'directions_bike':
        return Icons.directions_bike;
      case 'eco':
        return Icons.eco;
      case 'local_drink':
        return Icons.local_drink;
      case 'power':
        return Icons.power;
      case 'directions_car':
        return Icons.directions_car;
      case 'shower':
        return Icons.shower;
      case 'smartphone':
        return Icons.smartphone;
      default:
        return Icons.help_outline;
    }
  }

  // Checklist Screen to use by user to input their carbons
  Widget checklistScreen() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...controller.carbonVariables.map((item) {
              switch (item.type) {
                case ChecklistType.boolean:
                  return checklistItem(
                    item.label,
                    item.value as RxBool,
                    item.iconName ?? '',
                  );
                case ChecklistType.numericInt:
                case ChecklistType.numericDouble:
                  return numericInput(
                    item.label,
                    item.value,
                    item.iconName ?? '',
                  );
              }
            }).toList(),

            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: defaultButton(
                    text: 'Save',
                    gradient: AppColors.buttonGradient,
                    onPressed: () async {
                      try {
                        await controller.saveChecklist(
                          controller.carbonVariables[9].value.value as double,
                          (controller.carbonVariables[0].value.value ? 1 : 0),
                          controller.carbonVariables[10].value.value as int,
                          controller.carbonVariables[11].value.value as int,
                          (controller.carbonVariables[1].value.value ? 1 : 0),
                          (controller.carbonVariables[2].value.value ? 1 : 0),
                          (controller.carbonVariables[3].value.value ? 1 : 0),
                          (controller.carbonVariables[4].value.value ? 1 : 0),
                          (controller.carbonVariables[5].value.value ? 1 : 0),
                          (controller.carbonVariables[6].value.value ? 1 : 0),
                          (controller.carbonVariables[7].value.value ? 1 : 0),
                          (controller.carbonVariables[8].value.value ? 1 : 0),
                        );
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Failed to recap, try check your internet connection',
                        );
                      }
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.reset,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text("Reset", style: TextStyle(color: Colors.green)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Recap Screen to use by user to see detail of their carbons
  Widget recapScreen() {
    var log = carbonLogController.todayLog.value!;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // gambar pulau diganti teks
                  Container(
                    height: 170,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'assets/images/islandsImages/island${log.islandPath}.png',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // total karbon
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: getCarbonColor(log.carbonLevel),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Your Total Carbon Is ${log.totalCarbon} kgCO₂",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // perbandingan lucu
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/decorationImages/mascotHappy.png',
                        scale: 17,
                      ),
                      SizedBox(height: 4),
                      // TODO: Implement unique con
                      Text(
                        "That's like a cow letting one rip 20 times!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // grafik diganti teks
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text("grafik", style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // TODAY GOALS COMPLETION TITLE
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today Goals Completion",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // TODAY GOALS COMPLETION CARDS
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
                    gradient: AppColors.primaryGradient,
                    textColor: AppColors.surface,
                  ),
                  GoalCard(
                    text: 'Eating more vegetables than meat',
                    showCarbonSaved: true,
                    carbonSaved: '0.7',
                    gradient: AppColors.secondaryGradient,
                    textColor: AppColors.surface,
                  ),
                  GoalCard(
                    text: 'Use reusable bottle like tumbler instead of plastic',
                    showCarbonSaved: true,
                    carbonSaved: '5',
                    gradient: AppColors.primaryGradient,
                    textColor: AppColors.surface,
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // NEXT GOALS TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
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
                  SizedBox(height: 4),
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

            SizedBox(height: 10),

            // NEXT GOALS CARDS
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
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
