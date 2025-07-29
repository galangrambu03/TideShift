// data/models/daily_carbon_log_model.dart
class CarbonLogModel {
  final int id;
  final int usersId;
  final String logDate;
  final double totalCarbon;
  final int carbonLevel;
  final int islandPath;
  final int carbonSaved;
  final double carTravelKm;
  final bool packagedFood;
  final int showerTimeMinutes;
  final int electronicTimeHours;
  final bool onlineShopping;
  final bool wasteFood;
  final bool airConditioningHeating;
  final bool noDriving;
  final bool plantMealThanMeat;
  final bool useTumbler;
  final bool saveEnergy;
  final bool separateRecycleWaste;

  CarbonLogModel({
    required this.id,
    required this.usersId,
    required this.logDate,
    required this.totalCarbon,
    required this.carbonLevel,
    required this.islandPath,
    required this.carbonSaved,
    required this.carTravelKm,
    required this.packagedFood,
    required this.showerTimeMinutes,
    required this.electronicTimeHours,
    required this.onlineShopping,
    required this.wasteFood,
    required this.airConditioningHeating,
    required this.noDriving,
    required this.plantMealThanMeat,
    required this.useTumbler,
    required this.saveEnergy,
    required this.separateRecycleWaste,
  });

  factory CarbonLogModel.fromJson(Map<String, dynamic> json) {
    return CarbonLogModel(
      id: json['id'],
      usersId: json['usersId'],
      logDate: json['logDate'],
      totalCarbon: (json['totalCarbon'] as num).toDouble(),
      carbonLevel: json['carbonLevel'],
      islandPath: json['IslandPath'],
      carbonSaved: json['carbonSaved'],
      carTravelKm: (json['carTravelKm'] as num).toDouble(),
      packagedFood: json['packagedFood'] == 1,
      showerTimeMinutes: json['showerTimeMinutes'],
      electronicTimeHours: json['electronicTimeHours'],
      onlineShopping: json['onlineShopping'] == 1,
      wasteFood: json['wasteFood'] == 1,
      airConditioningHeating: json['airConditioningHeating'] == 1,
      noDriving: json['noDriving'] == 1,
      plantMealThanMeat: json['plantMealThanMeat'] == 1,
      useTumbler: json['useTumbler'] == 1,
      saveEnergy: json['saveEnergy'] == 1,
      separateRecycleWaste: json['separateRecycleWaste'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usersId': usersId,
      'logDate': logDate,
      'totalCarbon': totalCarbon,
      'carbonLevel': carbonLevel,
      'islandPath': islandPath,
      'carbonSaved': carbonSaved,
      'carTravelKm': carTravelKm,
      'packagedFood': packagedFood ? 1 : 0,
      'showerTimeMinutes': showerTimeMinutes,
      'electronicTimeHours': electronicTimeHours,
      'onlineShopping': onlineShopping ? 1 : 0,
      'wasteFood': wasteFood ? 1 : 0,
      'airConditioningHeating': airConditioningHeating ? 1 : 0,
      'noDriving': noDriving ? 1 : 0,
      'plantMealThanMeat': plantMealThanMeat ? 1 : 0,
      'useTumbler': useTumbler ? 1 : 0,
      'saveEnergy': saveEnergy ? 1 : 0,
      'separateRecycleWaste': separateRecycleWaste ? 1 : 0,
    };
  }
}
