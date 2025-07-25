import 'dart:math';

import 'package:ecomagara/datasource/local/unique_fact.dart';
import 'package:ecomagara/datasource/models/factModel.dart';
import 'package:ecomagara/domain/repositories/fact_repository.dart';

class FactImpl implements FactRepository {
  final UniqueFactLocalDatasource datasource;

  FactImpl({required this.datasource});

  @override
  Future<FactModel> getRandomFact() async {
    final allFacts = await datasource.loadAllFacts();
    final randomIndex = Random().nextInt(allFacts.length);
    return allFacts[randomIndex];
  }
}
