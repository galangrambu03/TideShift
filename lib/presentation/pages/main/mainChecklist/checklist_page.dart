import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/datasource/models/ChecklistItemModel.dart';
import 'package:ecomagara/presentation/widgets/defaultButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'checklist_controller.dart';

class ChecklistPage extends StatelessWidget {
  final controller = Get.put(ChecklistController());

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
      body: SafeArea(
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
                      onPressed: controller.saveChecklist,
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
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // checklist tile for true/false input
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

  // checklist tile for numeric input
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
                  // addjust the numeric input type according to the variable data type
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

  // return the flutter icon corresponding to the icon name string from the variable
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
}
