import 'package:ecomagara/datasource/models/diyModel.dart';

abstract class DiyRepository {
  Future<List<DiyModel>> getDiyProjects();
}
