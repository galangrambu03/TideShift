

import 'package:ecomagara/datasource/local/disasterContent.dart';
import 'package:ecomagara/datasource/local/diyContentDatasource.dart';
import 'package:ecomagara/datasource/models/disasterModel.dart';
import 'package:ecomagara/datasource/models/diyModel.dart';
import 'package:ecomagara/domain/repositories/disaster_repository.dart';

class DisasterImpl implements DisasterRepository {
  final DisasterLocalDatasource dataSource;

  DisasterImpl(this.dataSource);

  @override
  Future<List<DisasterModel>> getDisasters() {
    return dataSource.fetchDisasters();
  }
}
