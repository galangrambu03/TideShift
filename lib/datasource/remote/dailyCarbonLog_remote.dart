import 'dart:convert';
import 'package:ecomagara/config/config.dart';
import 'package:ecomagara/datasource/models/DailyCarbonLogModel.dart';
import 'package:ecomagara/datasource/models/carbonLog.dart';
import 'package:ecomagara/datasource/models/checkSubmission.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class DailyCarbonLogRemoteDataSource {
  final String baseUrl = AppConfig.localUrl;
  
  // Submit daily carbon log (POST)
  Future<FuzzyModel> submitChecklist(Map<String, dynamic> payload) async {
    // ambil user token dari FirebaseAuth
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final authToken = await user.getIdToken();

    final response = await http.post(
      Uri.parse('$baseUrl/submit-checklist'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
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

    final response = await http.get(
      Uri.parse('$baseUrl/check-today-submission'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return CheckSubmissionResult.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Failed to check submission');
    }
  }

  // Ambil log hari ini saja
  Future<List<CarbonLogModel>> getTodayLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");
    final authToken = await user.getIdToken();

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await http.get(
      Uri.parse('$baseUrl/daily-carbon-logs?date_from=$today'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final logs = data['logs'] as List;
      return logs.map((json) => CarbonLogModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch today logs: ${response.body}');
    }
  }

  // Ambil log 5 bulan terakhir (jika tersedia)
  Future<List<CarbonLogModel>> getRecentLogs({int page = 1, int perPage = 100}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");
    final authToken = await user.getIdToken();

    final fiveMonthsAgo = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 30 * 5)));

    final response = await http.get(
      Uri.parse('$baseUrl/daily-carbon-logs?date_from=$fiveMonthsAgo&page=$page&per_page=$perPage'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final logs = data['logs'] as List;
      return logs.map((json) => CarbonLogModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch recent logs: ${response.body}');
    }
  }
}
