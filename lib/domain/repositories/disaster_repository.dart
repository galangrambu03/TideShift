
import 'package:ecomagara/datasource/models/disasterModel.dart';

abstract class DisasterRepository {
  Future<List<DisasterModel>> getDisasters();
}
