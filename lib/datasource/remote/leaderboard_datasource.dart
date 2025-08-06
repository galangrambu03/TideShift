// leaderboard_datasource.dart
import 'dart:convert';
import 'package:ecomagara/config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class LeaderboardDatasource {
  final String baseUrl = AppConfig.localUrl;

Future<List<Map<String, dynamic>>> fetchLeaderboard() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('User not logged in');
  }

  final authToken = await user.getIdToken();
  final Uri url = Uri.parse('$baseUrl/leaderboard');
  print('Fetching leaderboard from: $url');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
  ).timeout(const Duration(seconds: 10));

  print('Leaderboard API status: ${response.statusCode}');
  print('Leaderboard API body: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data is Map && data.containsKey('leaderboard')) {
      final List<dynamic> leaderboard = data['leaderboard'];
      return leaderboard
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (data is List) {
      return data
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    throw Exception('Invalid response format: ${response.body}');
  } else {
    throw Exception('Failed to load leaderboard: ${response.statusCode}');
  }
}

}
