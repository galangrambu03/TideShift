import 'dart:convert';
import 'package:ecomagara/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/dailyGoalsResponseModel.dart';

class DailyGoalsRemoteDataSource {
  final String baseUrl = AppConfig.localUrl;

  Future<http.Response> _retryRequest(
    Future<http.Response> Function() requestFn,
  ) async {
    final response = await requestFn();

    if (response.statusCode == 401 &&
        response.body.contains("Token used too early")) {
      print("⚠ Token too early, retrying in 2 seconds...");
      await Future.delayed(Duration(seconds: 2));
      return await requestFn();
    }

    return response;
  }

  Future<DailyGoalsResponseModel> fetchLatestGoals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final authToken = await user.getIdToken();

    final response = await _retryRequest(() {
      return http.get(
        Uri.parse('$baseUrl/latest-goals'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DailyGoalsResponseModel.fromJson(data);
    } else {
      throw Exception('Failed to load goals: ${response.body}');
    }
  }
}
