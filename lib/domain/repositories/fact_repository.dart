import 'package:ecomagara/datasource/models/factModel.dart';

abstract class FactRepository {
  Future<FactModel> getRandomFact();
}