import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:ecomagara/config/config.dart';
import 'package:ecomagara/datasource/models/goalsAchievedModel.dart';

class GoalsAchievedRemoteDatasource {
  final String baseUrl = AppConfig.localUrl;
  final http.Client client = http.Client();

  Future<http.Response> _retryRequest(Future<http.Response> Function() requestFn) async {
    final response = await requestFn();

    if (response.statusCode == 401 && response.body.contains("Token used too early")) {
      print("⚠ Token too early, retrying in 2 seconds...");
      await Future.delayed(const Duration(seconds: 2));
      return await requestFn();
    }

    return response;
  }

  Future<GoalsAchievedModel> fetchGoalsAchieved() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final authToken = await user.getIdToken();

    final response = await _retryRequest(() {
      return client.get(
        Uri.parse('$baseUrl/check-goals-achieved'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
    });

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return GoalsAchievedModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to fetch goals achieved: ${response.body}');
    }
  }
}
