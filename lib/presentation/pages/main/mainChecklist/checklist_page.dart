import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/datasource/models/ChecklistItemModel.dart';
import 'package:ecomagara/functions/getCarbonColor_switch.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/carbonUnit_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/dailyGoals_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/goalsAchived_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/carbonLog_controller.dart';
import 'package:ecomagara/presentation/widgets/defaultButton.dart';
import 'package:ecomagara/presentation/widgets/donutChart.dart';
import 'package:ecomagara/presentation/widgets/goalCard.dart';
import 'package:ecomagara/user_controller.dart';
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
  final GoalsAchievedController goalsAchievedController = Get.find();
  final UserController userController = Get.find();

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
                              .value, // carTravelKm (index 9)
                          controller.carbonVariables[0].value.value
                              ? 1
                              : 0, // packagedFood (index 0)
                          controller
                              .carbonVariables[10]
                              .value
                              .value, // showerTimeMinutes (index 10)
                          controller
                              .carbonVariables[11]
                              .value
                              .value, // electronicDeviceTimeHours (index 11)
                          controller.carbonVariables[1].value.value
                              ? 1
                              : 0, // onlineShopping (index 1)
                          controller.carbonVariables[2].value.value
                              ? 1
                              : 0, // wasteFood (index 2)
                          controller.carbonVariables[3].value.value
                              ? 1
                              : 0, // airConditioningHeating (index 3)
                          controller.carbonVariables[4].value.value
                              ? 1
                              : 0, // noDriving (walk/bike/public transport) (index 4)
                          controller.carbonVariables[5].value.value
                              ? 1
                              : 0, // plantMealThanMeat (index 5)
                          controller.carbonVariables[6].value.value
                              ? 1
                              : 0, // useTumbler (index 6)
                          controller.carbonVariables[7].value.value
                              ? 1
                              : 0, // saveEnergy (turn off lights) (index 7)
                          controller.carbonVariables[8].value.value
                              ? 1
                              : 0, // separateRecycleWaste (index 8)
                        );

                        await dailyGoalsController.fetchGoals();
                        await goalsAchievedController.fetchGoalsAchieved();
                        await userController.fetchUserProfile();
                        await _loadHumor(); // refresh humor
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

  // RECAP SCREEN: Recap Screen to use by user to see detail of their carbons
  Widget recapScreen() {
    if (carbonLogController.todayLog.value == null) {
      return Center(
        child: LoadingAnimationWidget.progressiveDots(
          color: AppColors.primary,
          size: 30,
        ),
      );
    }

    final GoalsAchievedController goalsAchievedController = Get.find();
    var log = carbonLogController.todayLog.value!;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // gambar pulau
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
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: getCarbonColor(log.carbonLevel),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Total Net Carbon Emission is ${log.totalCarbon} kgCO₂",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  Column(
                    children: [
                      Image.asset(
                        'assets/images/decorationImages/mascotHappy.png',
                        scale: 17,
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          carbonUnitController.humorText.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

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
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // grafik
                  Obx(() {
                    if (carbonLogController.todayLog.value != null) {
                      final categoryData = carbonLogController
                          .calculateCarbonDistribution(
                            carbonLogController.todayLog.value!,
                          );
                      return CarbonDonutChart(data: categoryData);
                    } else {
                      return const SizedBox();
                    }
                  }),

                  const SizedBox(height: 50),
                ],
              ),
            ),

            // TODAY GOALS COMPLETION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Obx(() {
                  final goalsData = goalsAchievedController.goalsAchieved.value;
                  if (goalsData == null) return const SizedBox();

                  final achievedGoals =
                      goalsData.goalsAchieved.entries
                          .where((e) => e.value == true)
                          .toList();

                  return Text(
                    "You've completed ${achievedGoals.length} goals, ${achievedGoals.length * 5} pts added to your account",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  );
                }),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 70,
              child: Obx(() {
                final goalsData = goalsAchievedController.goalsAchieved.value;
                if (goalsData == null) {
                  return const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty_rounded,
                          size: 20,
                          color: AppColors.textGrey,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "No goals data",
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  );
                }

                final allGoals =
                    goalsData.goalsAchieved.entries
                        .where((e) => e.value != null) // filter yang tidak null
                        .toList();

                if (allGoals.isEmpty) {
                  return const Center(child: Text("No goals data"));
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: allGoals.length,
                  itemBuilder: (context, index) {
                    final goal = allGoals[index];
                    final isNumeric = [
                      'carTravelKmGoal',
                      'showerTimeMinutesGoal',
                      'electronicTimeHoursGoal',
                    ].contains(goal.key);

                    return GoalCard(
                      text:
                          isNumeric
                              ? getNumericGoalDescription(
                                goal.key,
                                goalsData.numericGoals[goal.key],
                              )
                              : _getGoalLabel(goal.key),
                      showCarbonSaved: !isNumeric,
                      carbonSaved: !isNumeric ? _getCarbonSaved(goal.key) : '',
                      gradient:
                          goal.value == true
                              ? AppColors.primaryGradient
                              : AppColors.secondaryGradient,
                      textColor: AppColors.surface,
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 25),

            // NEXT GOALS TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.primary),
                      const SizedBox(width: 8),
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
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Goals that you need try to achieve for the next recap!",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

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
                        child: const Center(
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

            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  String _getGoalLabel(String key) {
    const labels = {
      // numeric goals
      'carTravelKmGoal': 'Try limit your vehicle usage to',
      'showerTimeMinutesGoal': 'Try limit your showers time to',
      'electronicTimeHoursGoal': 'Try reduce your screen time to',

      // negative goals
      'packagedFood': 'Eat unpackaged or fresh food',
      'onlineShopping': 'Limit online shopping habits',
      'wasteFood': 'Avoid food waste',
      'airConditioningHeating': 'Reduce air conditioning or heating usage',

      // positive goals
      'noDriving': 'Use environmentally friendly transportation',
      'plantMealThanMeat': 'Eat more plant based meals',
      'useTumbler': 'Bring your own tumbler or reusable bottle',
      'saveEnergy': 'Practice energy saving at home',
      'separateRecycleWaste': 'Separate waste for recycling',
    };

    return labels[key] ?? key;
  }

  String getNumericGoalDescription(String key, num? value) {
    if (value == null) return '';
    switch (key) {
      case 'carTravelKmGoal':
        return 'Try limit your vehicle usage to $value km';
      case 'showerTimeMinutesGoal':
        return 'Try limit your shower time to $value minutes';
      case 'electronicTimeHoursGoal':
        return 'Try reduce your screen time to $value hours';
      default:
        return '';
    }
  }

  String _getGoalUnit(String key) {
    const units = {
      'carTravelKmGoal': 'km',
      'showerTimeMinutesGoal': 'minutes',
      'electronicTimeHoursGoal': 'hours',
    };
    return units[key] ?? '';
  }

  String _getCarbonSaved(String key) {
    const carbonValues = {
      'noDriving': '4',
      'plantMealThanMeat': '0.7',
      'useTumbler': '5',
      'saveEnergy': '2',
      'separateRecycleWaste': '1',
    };
    return carbonValues[key] ?? '0';
  }
}
