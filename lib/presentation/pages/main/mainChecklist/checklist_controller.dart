import 'package:ecomagara/datasource/models/ChecklistItemModel.dart';
import 'package:get/get.dart';

class ChecklistController extends GetxController {
  // list of carbon variables questions content
  final carbonVariables = <ChecklistItem>[
    ChecklistItem(
      label: "Did you eat food packaged in plastic or vinyl?",
      type: ChecklistType.boolean,
      value: false.obs,
      factor: 0.5,
      iconName: 'emoji_food_beverage',
    ),
    ChecklistItem(
      label: "Did you do any online shopping (including deliveries) today?",
      type: ChecklistType.boolean,
      value: false.obs,
      factor: 1.0,
      iconName: 'shopping_cart',
    ),
    ChecklistItem(
      label: "Did you have any food waste today?",
      type: ChecklistType.boolean,
      value: false.obs,
      factor: 0.9,
      iconName: 'delete',
    ),
    ChecklistItem(
      label: "Did you use air conditioning or heating today?",
      type: ChecklistType.boolean,
      value: false.obs,
      factor: 1.5,
      iconName: 'autorenew',
    ),
    ChecklistItem(
      label: "Did you choose to walk, bike, or use public transportation instead of driving?",
      type: ChecklistType.boolean,
      value: false.obs,
      factor: -1.0,
      iconName: 'directions_bike',
    ),
    ChecklistItem(
      label: "Did you eat mostly vegetables or plant-based meals instead of meat?",
      type: ChecklistType.boolean,
      value: false.obs,
      factor: -2.0,
      iconName: 'eco',
    ),
    ChecklistItem(
      label: "Did you use a tumbler or reusable container instead of a disposable one?",
      type: ChecklistType.boolean,
      value: false.obs,
      factor: -2.0,
      iconName: 'local_drink',
    ),
    ChecklistItem(
      label: "Did you turn off unused lights, or unplug devices you weren't using?",
      type: ChecklistType.boolean,
      value: false.obs,
      factor: -0.3,
      iconName: 'power',
    ),
    ChecklistItem(
      label: "Did you properly separate and recycle your waste?",
      type: ChecklistType.boolean,
      value: false.obs,
      factor: -0.7,
      iconName: 'autorenew',
    ),
    ChecklistItem(
      label: "How many kilometers did you travel by car today? (km)",
      type: ChecklistType.numericDouble,
      value: 0.0.obs,
      factor: 0.21,
      iconName: 'directions_car',
    ),
    ChecklistItem(
      label: "How many minutes did you spend showering today? (minutes)",
      type: ChecklistType.numericInt,
      value: 0.obs,
      factor: 0.05,
      iconName: 'shower',
    ),
    ChecklistItem(
      label: "How many hours did you spend using electronic devices today? (hours)",
      type: ChecklistType.numericInt,
      value: 0.obs,
      factor: 0.06,
      iconName: 'smartphone',
    ),
  ];

  // FUNCTION - reset value of checklist items
  void reset() {
    for (var item in carbonVariables) {
      if (item.value is RxBool) item.value.value = false;
      if (item.value is RxInt) item.value.value = 0;
      if (item.value is RxDouble) item.value.value = 0.0;
    }
  }

  // FUNCTION - calculate total carbon footprint based on checklist items
  double getTotalCarbon() {
    double total = 0.0;
    for (var item in carbonVariables) {
      switch (item.type) {
        case ChecklistType.boolean:
          if (item.value.value == true) total += item.factor;
          break;
        case ChecklistType.numericInt:
          total += (item.value.value as int) * item.factor;
          break;
        case ChecklistType.numericDouble:
          total += (item.value.value as double) * item.factor;
          break;
      }
    }
    return total;
  }

  //TODO: Implement function to calculate value of carbon by each categories

  //TODO: Continue this function to save carbon data to user's database
  void saveChecklist() {
    final total = getTotalCarbon();
    print("Total Carbon: ${total.toStringAsFixed(2)} kg CO₂");
  }
}
