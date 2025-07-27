import 'package:ecomagara/datasource/models/leaderboardUserModel.dart';
import 'package:ecomagara/datasource/models/userModel.dart';

abstract class UserRepository {
  Future<void> syncUser({
    required String username,
    required String profilePicture,
  });
  Future<UserModel> getProfile();
  Future<List<LeaderboardUserModel>> getLeaderboard();
}
