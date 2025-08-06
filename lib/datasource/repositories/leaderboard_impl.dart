// leaderboard_repository_impl.dart


import 'package:ecomagara/datasource/remote/leaderboard_datasource.dart';
import 'package:ecomagara/domain/repositories/leaderboard_repository.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardDatasource datasource;

  LeaderboardRepositoryImpl(this.datasource);

  @override
  Future<List<LeaderboardUser>> getLeaderboard() async {
    final rawList = await datasource.fetchLeaderboard();
    return rawList.map((json) => LeaderboardUser(
      username: json['username'],
      points: json['points'],
      profilePicture: json['profilePicture']
    )).toList();
  }
}
