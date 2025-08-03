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

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value == "1" || value.toLowerCase() == "true";
    return false;
  }

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
      packagedFood: _parseBool(json['packagedFood']),
      showerTimeMinutes: json['showerTimeMinutes'],
      electronicTimeHours: json['electronicTimeHours'],
      onlineShopping: _parseBool(json['onlineShopping']),
      wasteFood: _parseBool(json['wasteFood']),
      airConditioningHeating: _parseBool(json['airConditioningHeating']),
      noDriving: _parseBool(json['noDriving']),
      plantMealThanMeat: _parseBool(json['plantMealThanMeat']),
      useTumbler: _parseBool(json['useTumbler']),
      saveEnergy: _parseBool(json['saveEnergy']),
      separateRecycleWaste: _parseBool(json['separateRecycleWaste']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usersId': usersId,
      'logDate': logDate,
      'totalCarbon': totalCarbon,
      'carbonLevel': carbonLevel,
      'IslandPath': islandPath,
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
