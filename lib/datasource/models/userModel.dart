class UserModel {
  final String email;
  final String username;
  final String profilePicture;
  final DateTime joinDate;
  final int points;
  final int currentIslandTheme;
  final String firebaseUid;

  UserModel({
    required this.email,
    required this.username,
    required this.profilePicture,
    required this.joinDate,
    required this.points,
    required this.currentIslandTheme,
    required this.firebaseUid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      username: json['username'],
      profilePicture: json['profilePicture'] ?? 'default.png',
      joinDate: DateTime.parse(json['joinDate']),
      points: json['points'] ?? 0,
      currentIslandTheme: json['currentIslandTheme'] ?? 0,
      firebaseUid: json['firebase_uid'],
    );
  }
}
