import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/datasource/models/ChecklistItemModel.dart';
import 'package:ecomagara/functions/getCarbonColor_switch.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/carbonUnit_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/dailyGoals_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/carbonLog_controller.dart';
import 'package:ecomagara/presentation/widgets/defaultButton.dart';
import 'package:ecomagara/presentation/widgets/donutChart.dart';
import 'package:ecomagara/presentation/widgets/goalCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'checklist_controller.dart';

class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final controller = Get.put(ChecklistController());
  final DailyCarbonLogController carbonLogController = Get.find();
  final CarbonUnitController carbonUnitController = Get.find();
  final DailyGoalsController dailyGoalsController = Get.find();

  @override
  void initState() {
    super.initState();
    if (carbonLogController.isTodaySubmited.value == true) {
      _loadHumor();
    }
  }

  Future<void> _loadHumor() async {
    await carbonUnitController.loadHumor(
      carbonLogController.todayLog.value!.totalCarbon,
    );
    print('HUMOUR TEXT: ${carbonUnitController.humorText}');
  }

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
        if (carbonLogController.isTodaySubmited.value) {
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
                          controller
                              .carbonVariables[9]
                              .value
                              .value, // carTravelKm
                          controller.carbonVariables[0].value.value
                              ? 1
                              : 0, // packagedFood
                          controller
                              .carbonVariables[10]
                              .value
                              .value, // showerTimeMinutes
                          controller
                              .carbonVariables[11]
                              .value
                              .value, // electronicDeviceTimeHours
                          controller.carbonVariables[6].value.value
                              ? 1
                              : 0, // onlineShopping
                          controller.carbonVariables[2].value.value
                              ? 1
                              : 0, // wasteFood
                          controller.carbonVariables[4].value.value
                              ? 1
                              : 0, // airConditioningHeating
                          controller.carbonVariables[5].value.value
                              ? 1
                              : 0, // noDriving
                          controller.carbonVariables[1].value.value
                              ? 1
                              : 0, // plantMealThanMeat
                          controller.carbonVariables[7].value.value
                              ? 1
                              : 0, // useTumbler
                          controller.carbonVariables[8].value.value
                              ? 1
                              : 0, // saveEnergy
                          controller.carbonVariables[3].value.value
                              ? 1
                              : 0, // separateRecycleWaste
                        );
                        await dailyGoalsController.fetchGoals();
                        _loadHumor(); // refresh humor
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Failed to submit checklist. Please try again later.',
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
    if (carbonLogController.todayLog.value == null) {
      return Center(
        child: LoadingAnimationWidget.progressiveDots(
          color: AppColors.primary,
          size: 30,
        ),
      );
    }
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
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'assets/images/islandsImages/island${log.islandPath}.png',
                    ),
                  ),
                  SizedBox(height: 16),

                  // total karbon
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: getCarbonColor(log.carbonLevel),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Total Net Carbon Emission is ${log.totalCarbon} kgCO₂",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // perbandingan lucu
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/decorationImages/mascotHappy.png',
                        scale: 17,
                      ),
                      SizedBox(height: 4),
                      // TODO: Implement unique con
                      Obx(
                        () => Text(
                          carbonUnitController.humorText.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // EMISSION DISTRIBUTION TITLE
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Emission Distribution by Activity",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Category based view. Reductions only affect their own category, unlike Net Carbon Emission which applies reductions globally.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 30),

                  // grafik diganti teks
                  Obx(() {
                    if (carbonLogController.todayLog.value != null) {
                      final categoryData = carbonLogController
                          .calculateCarbonDistribution(
                            carbonLogController.todayLog.value!,
                          );

                      return CarbonDonutChart(data: categoryData);
                    } else {
                      return SizedBox();
                    }
                  }),

                  SizedBox(height: 50),
                ],
              ),
            ),

            // TODAY GOALS COMPLETION TITLE
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: Align(
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

            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "You've completed x goals, x pts added to your account",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),

            SizedBox(height: 12),

            // TODAY GOALS COMPLETION CARDS
            SizedBox(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 8),
                children: [
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
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
              child: Obx(() {
                if (dailyGoalsController.isLoading.value) {
                  return Center(
                    child: LoadingAnimationWidget.progressiveDots(
                      color: AppColors.primary,
                      size: 30,
                    ),
                  );
                }

                if (dailyGoalsController.goals.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 70,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "No new next goals today, you're doing great!",
                            style: TextStyle(
                              color: AppColors.surface,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: dailyGoalsController.goals.length,
                  itemBuilder: (context, index) {
                    final goal = dailyGoalsController.goals[index];

                    // Filter goal yang nilainya 0.0
                    if (goal.value == 0.0) {
                      return const SizedBox.shrink();
                    }

                    return GoalCard(
                      text:
                          goal.unit != null
                              ? '${goal.title} ${goal.value} ${goal.unit}'
                              : goal.title,
                      showCarbonSaved: goal.value != null,
                      carbonSaved: goal.value?.toStringAsFixed(1) ?? '',
                      color: AppColors.surface,
                      textColor: Colors.black87,
                    );
                  },
                );
              }),
            ),

            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
