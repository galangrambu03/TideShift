import 'package:ecomagara/datasource/models/carbonUnitModel.dart';

abstract class CarbonUnitRepository {
  Future<List<CarbonUnit>> getCarbonUnits();
  Future<String> getRandomHumorLabel(double totalCarbon);
}
