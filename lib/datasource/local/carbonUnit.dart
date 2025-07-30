import 'dart:convert';
import 'package:ecomagara/datasource/models/carbonUnitModel.dart';
import 'package:flutter/services.dart' show rootBundle;

abstract class CarbonUnitDataSource {
  Future<List<CarbonUnit>> fetchCarbonUnits();
}

class CarbonUnitLocalDataSource implements CarbonUnitDataSource {
  @override
  Future<List<CarbonUnit>> fetchCarbonUnits() async {
    final String response = await rootBundle.loadString('assets/jsons/carbonUnits.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((item) => CarbonUnit.fromJson(item)).toList();
  }
}
