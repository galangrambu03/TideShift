import 'dart:convert';
import 'package:ecomagara/datasource/models/factModel.dart';
import 'package:flutter/services.dart';

class UniqueFactLocalDatasource {
  Future<List<FactModel>> loadAllFacts() async {
    final String response = await rootBundle.loadString('assets/jsons/uniqueFacts.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((fact) => FactModel.fromJson(fact)).toList();
  }
}

