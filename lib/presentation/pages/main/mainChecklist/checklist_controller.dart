import 'package:ecomagara/datasource/models/ChecklistItemModel.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/goalsAchived_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/carbonLog_controller.dart';
import 'package:get/get.dart';

class ChecklistController extends GetxController {
  final DailyCarbonLogController _dailyCarbonLogController = Get.find();
  final GoalsAchievedController _goalsAchievedController = Get.find();
  var isTodaySubmited = false.obs;

  @override
  void onInit() async {
    super.onInit();

    // cek status submit saat inisialisasi
    await _dailyCarbonLogController.checkTodaySubmission();
    isTodaySubmited.value = _dailyCarbonLogController.isTodaySubmited.value;

    if (isTodaySubmited.value) {
      await _dailyCarbonLogController.fetchTodayLog();
      await _goalsAchievedController.fetchGoalsAchieved();
    }
  }

  // daftar variabel checklist
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
      label:
          "Did you choose to walk, bike, or use public transportation instead of driving?",
      type: ChecklistType.boolean,
      value: false.obs,
      factor: -1.0,
      iconName: 'directions_bike',
    ),
    ChecklistItem(
      label:
          "Did you eat mostly vegetables or plant-based meals instead of meat?",
      type: ChecklistType.boolean,
      value: false.obs,
      factor: -2.0,
      iconName: 'eco',
    ),
    ChecklistItem(
      label:
          "Did you use a tumbler or reusable container instead of a disposable one?",
      type: ChecklistType.boolean,
      value: false.obs,
      factor: -0.2,
      iconName: 'local_drink',
    ),
    ChecklistItem(
      label:
          "Did you turn off unused lights, or unplug devices you weren't using?",
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
      label:
          "How many hours did you spend using electronic devices today? (hours)",
      type: ChecklistType.numericInt,
      value: 0.obs,
      factor: 0.06,
      iconName: 'smartphone',
    ),
  ];

  // reset checklist
  void reset() {
    for (var item in carbonVariables) {
      if (item.value is RxBool) item.value.value = false;
      if (item.value is RxInt) item.value.value = 0;
      if (item.value is RxDouble) item.value.value = 0.0;
    }
  }

  // simpan checklist ke backend
  Future<void> saveChecklist(
    double carTravelKm,
    int packagedFood,
    int showerTimeMinutes,
    int electronicDeviceTimeHours,
    int onlineShopping,
    int wasteFood,
    int airConditioningHeating,
    int noDriving,
    int plantMealThanMeat,
    int useTumbler,
    int saveEnergy,
    int separateRecycleWaste,
  ) async {
    final checklistData = {
      "carTravelKm": carTravelKm,
      "packagedFood": packagedFood,
      "showerTimeMinutes": showerTimeMinutes,
      "electronicTimeHours": electronicDeviceTimeHours,
      "onlineShopping": onlineShopping,
      "wasteFood": wasteFood,
      "airConditioningHeating": airConditioningHeating,
      "noDriving": noDriving,
      "plantMealThanMeat": plantMealThanMeat,
      "useTumbler": useTumbler,
      "saveEnergy": saveEnergy,
      "separateRecycleWaste": separateRecycleWaste,
    };

    await _dailyCarbonLogController.submitDailyChecklist(checklistData);
    await _dailyCarbonLogController.checkTodaySubmission();
    await _dailyCarbonLogController.fetchTodayLog();

    // update status submit
    isTodaySubmited.value = _dailyCarbonLogController.isTodaySubmited.value;
  }

  Future<void> fetchChecklistStatus() async {
    await _dailyCarbonLogController.checkTodaySubmission();
    isTodaySubmited.value = _dailyCarbonLogController.isTodaySubmited.value;

    if (isTodaySubmited.value) {
      await _dailyCarbonLogController.fetchTodayLog();
    }
  }

  void clear() {
    reset();
    isTodaySubmited.value = false;
  }
}
