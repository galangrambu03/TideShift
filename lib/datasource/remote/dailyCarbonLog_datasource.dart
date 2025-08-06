import 'dart:convert';
import 'package:ecomagara/config/config.dart';
import 'package:ecomagara/datasource/models/DailyCarbonLogModel.dart';
import 'package:ecomagara/datasource/models/FuzzyModel.dart';
import 'package:ecomagara/datasource/models/checkSubmission.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DailyCarbonLogRemoteDataSource {
  final String baseUrl = AppConfig.localUrl;

  // fungsi retry request untuk mengatasi token used too early
  Future<http.Response> _retryRequest(Future<http.Response> Function() requestFn) async {
    final response = await requestFn();

    if (response.statusCode == 401 &&
        response.body.contains("Token used too early")) {
      print("⚠ Token too early, retrying in 2 seconds...");
      await Future.delayed(Duration(seconds: 2));
      return await requestFn();
    }

    return response;
  }

  // Submit daily carbon log (POST)
  Future<FuzzyModel> submitChecklist(Map<String, dynamic> payload) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final authToken = await user.getIdToken();

    final response = await _retryRequest(() {
      return http.post(
        Uri.parse('$baseUrl/submit-checklist'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(payload),
      );
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return FuzzyModel.fromJson(data);
    } else {
      throw Exception('Failed to submit checklist: ${response.body}');
    }
  }

  // Check today's submission (GET)
  Future<CheckSubmissionResult> checkTodaySubmission() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final authToken = await user.getIdToken();

    final response = await _retryRequest(() {
      return http.get(
        Uri.parse('$baseUrl/check-today-submission'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
    });

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return CheckSubmissionResult.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Failed to check submission');
    }
  }

  // Get today log (GET)
  Future<CarbonLogModel?> getTodayLog() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final authToken = await user.getIdToken();
    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await _retryRequest(() {
      return http.get(
        Uri.parse(
          '$baseUrl/daily-carbon-logs?date_from=$todayDate&per_page=1&today_only=true',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final logs = data['logs'] as List;
      if (logs.isNotEmpty) {
        try {
          return CarbonLogModel.fromJson(logs.first);
        } catch (e, stack) {
          print('Parsing error: $e');
          print('Stacktrace: $stack');
          print('Raw log: ${logs.first}');
          rethrow;
        }
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to fetch today\'s log: ${response.body}');
    }
  }

  // Get logs up to 5 month ago (GET)
  Future<List<CarbonLogModel>> getRecentLogs({
    int page = 1,
    int perPage = 100,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");
    final authToken = await user.getIdToken();

    final fiveMonthsAgo = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now().subtract(Duration(days: 30 * 5)));

    final response = await _retryRequest(() {
      return http.get(
        Uri.parse(
          '$baseUrl/daily-carbon-logs?date_from=$fiveMonthsAgo&page=$page&per_page=$perPage',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final logs = data['logs'] as List;
      return logs.map((json) => CarbonLogModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch recent logs: ${response.body}');
    }
  }
}
