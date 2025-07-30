import 'dart:math';

import 'package:ecomagara/datasource/local/carbonUnit.dart';
import 'package:ecomagara/datasource/models/carbonUnitModel.dart';
import 'package:ecomagara/domain/repositories/carbonUnits_repository.dart';
class CarbonUnitRepositoryImpl implements CarbonUnitRepository {
  final CarbonUnitDataSource dataSource;

  CarbonUnitRepositoryImpl({required this.dataSource});

  @override
  Future<List<CarbonUnit>> getCarbonUnits() async {
    return await dataSource.fetchCarbonUnits();
  }

  @override
  Future<String> getRandomHumorLabel(double totalCarbon) async {
  final units = await getCarbonUnits();
  final random = Random();
  final unit = units[random.nextInt(units.length)];

  if (totalCarbon <= 0) {
    return "Amazing! your total net carbon emission is 0!";
  }

  final count = (totalCarbon / unit.carbonWeight).floor().clamp(1, 9999);
  return unit.label.replaceAll("{carbon:carbonWeight}", count.toString());
}

}
