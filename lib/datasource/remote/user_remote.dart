import 'dart:convert';
import 'package:ecomagara/datasource/models/leaderboardUserModel.dart';
import 'package:ecomagara/datasource/models/userModel.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class UserDatasource {
  // Ganti dengan IP lokal Flask kamu saat testing di device
  final String baseUrl = 'http://192.168.1.25:5000';

  /// Get Firebase ID token
  Future<String> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");
    final idToken = await user.getIdToken();
    if (idToken == null) throw Exception("Failed to retrieve ID token");
    return idToken;
  }

  /// Sync user after first sign up (POST /me)
  Future<void> syncUser({
    required String username,
    required String profilePicture,
  }) async {
    final idToken = await _getIdToken();

    final response = await http.post(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'username': username,
        'profilePicture': profilePicture,
      }),
    );
    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to sync user: ${response.body}");
    }
  }

  /// Get profile of current logged-in user (GET /me)
  Future<UserModel> getProfile() async {
    final idToken = await _getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Authorization': 'Bearer $idToken'},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to get profile: ${response.body}");
    }

    final json = jsonDecode(response.body);
    return UserModel.fromJson(json);
  }

  /// Get leaderboard data (GET /leaderboard)
  Future<List<LeaderboardUserModel>> getLeaderboard() async {
    final idToken = await _getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl/leaderboard'),
      headers: {'Authorization': 'Bearer $idToken'},
    );
    
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch leaderboard: ${response.body}");
    }

    final data = jsonDecode(response.body);
    final list = List<Map<String, dynamic>>.from(data['leaderboard']);

    return list.map((e) => LeaderboardUserModel.fromJson(e)).toList();
  }
}
