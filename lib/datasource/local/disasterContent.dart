import 'dart:convert';

import 'package:ecomagara/datasource/models/disasterModel.dart';
import 'package:flutter/services.dart';

class DisasterLocalDatasource {
  final String path;

  DisasterLocalDatasource({this.path = 'assets/jsons/disasterContent.json'});

  @override
  Future<List<DisasterModel>> fetchDisasters() async {
    final jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => DisasterModel.fromJson(json)).toList();
  }
}