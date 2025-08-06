import 'package:ecomagara/datasource/models/leaderboardUserModel.dart';
import 'package:ecomagara/datasource/models/userModel.dart';
import 'package:ecomagara/datasource/remote/user_datasource.dart';
import 'package:ecomagara/domain/repositories/user_repostitory.dart';


class UserRepositoryImpl implements UserRepository {
  final UserDatasource datasource;

  UserRepositoryImpl({required this.datasource});

  @override
  Future<void> syncUser({required String username, required String profilePicture}) {
    return datasource.syncUser(username: username, profilePicture: profilePicture);
  }

  @override
  Future<UserModel> getProfile() {
    return datasource.getProfile();
  }

  @override
  Future<List<LeaderboardUserModel>> getLeaderboard() {
    return datasource.getLeaderboard();
  }
}
