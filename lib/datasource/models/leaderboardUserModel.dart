// ignore: file_names
class LeaderboardUserModel {
  final String username;
  final int points;

  LeaderboardUserModel({
    required this.username,
    required this.points,
  });

  factory LeaderboardUserModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardUserModel(
      username: json['username'] ?? '',
      points: json['points'] ?? 0,
    );
  }
}
