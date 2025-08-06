// leaderboard_repository.dart
abstract class LeaderboardRepository {
  Future<List<LeaderboardUser>> getLeaderboard();
}

class LeaderboardUser {
  final String username;
  final int points;
  final String profilePicture;

  LeaderboardUser({required this.username, required this.points, required this.profilePicture});
}
