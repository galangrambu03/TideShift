

import 'package:ecomagara/datasource/local/diyContentDatasource.dart';
import 'package:ecomagara/datasource/models/diyModel.dart';
import 'package:ecomagara/domain/repositories/diy_repository.dart';

class DiyRepositoryImpl implements DiyRepository {
  final DiyLocalDataSource dataSource;

  DiyRepositoryImpl(this.dataSource);

  @override
  Future<List<DiyModel>> getDiyProjects() {
    return dataSource.fetchDiyProjects();
  }
}
