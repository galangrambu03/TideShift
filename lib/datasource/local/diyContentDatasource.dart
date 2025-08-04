import 'dart:convert';
import 'package:ecomagara/datasource/models/diyModel.dart';
import 'package:flutter/services.dart' show rootBundle;

class DiyLocalDataSource {
  final String path;

  DiyLocalDataSource({this.path = 'assets/jsons/diyContent.json'});

  @override
  Future<List<DiyModel>> fetchDiyProjects() async {
    final jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => DiyModel.fromJson(json)).toList();
  }
}
