import 'package:ecomagara/datasource/models/DailyCarbonLogModel.dart';
import 'package:ecomagara/domain/repositories/dailyCarbonLog_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CalendarController extends GetxController {
  final logs = <CarbonLogModel>[].obs;
  final pageController = PageController(initialPage: 0);
  final currentPageIndex = 0.obs;
  final today = DateTime.now();

  final DailyCarbonLogRepository repository;

  CalendarController({required this.repository});

  @override
  void onInit() async {
    super.onInit();
    print("📅 CalendarController initialized");
    await fetchRecentLogs();
  }

  Future<void> fetchRecentLogs() async {
    try {
      print("🔄 Fetching recent logs (last 3 months)...");
      final recentLogs = await repository.getRecentLogs();
      logs.assignAll(recentLogs);

      print("✅ Fetched ${logs.length} logs");
      for (var log in logs) {
        print(
          "  - ${log.logDate} | Carbon Level: ${log.carbonLevel} | Total Carbon: ${log.totalCarbon}",
        );
      }
    } catch (e) {
      print("❌ Error fetching logs: $e");
    }
  }

  DateTime getMonthFromIndex(int index) {
    final month = DateTime(today.year, today.month - index);
    print("📌 Viewing month: ${month.year}-${month.month}");
    return month;
  }

  CarbonLogModel? getLogForDate(DateTime date) {
    print("🔍 Searching log for: ${date.year}-${date.month}-${date.day}");
    final log = logs.firstWhereOrNull((log) {
      final logDate = DateTime.parse(log.logDate);
      return logDate.year == date.year &&
          logDate.month == date.month &&
          logDate.day == date.day;
    });

    if (log != null) {
      print(
        "✅ Found log for ${date.toIso8601String()}: Carbon Level ${log.carbonLevel}",
      );
    } else {
      print("⚠ No log for ${date.toIso8601String()}");
    }

    return log;
  }

  String? getAsset(int? level) {
    print("🎨 Getting asset for level: $level");
    if (level == null || level <= 0 || level > 5) return null;
    return 'assets/images/islandsImages/island${level - 1}.png';
  }

  List<DateTime?> generateDaysForMonth(DateTime month) {
    print("📅 Generating days for: ${month.year}-${month.month}");
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    final days = <DateTime?>[];
    final weekdayOffset = firstDay.weekday % 7;

    print(
      "  First day: $firstDay | Last day: $lastDay | Offset: $weekdayOffset",
    );

    for (int i = 0; i < weekdayOffset; i++) {
      days.add(null);
    }

    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    while (days.length % 7 != 0) {
      days.add(null);
    }

    print("  Total calendar cells: ${days.length}");
    return days;
  }

  bool isSameDay(DateTime a, DateTime b) {
    final same = a.year == b.year && a.month == b.month && a.day == b.day;
    print(
      "📌 Comparing days: ${a.toIso8601String()} vs ${b.toIso8601String()} => $same",
    );
    return same;
  }

  void clear() {
    print("🧹 Clearing CalendarController data");
    logs.clear();
    currentPageIndex.value = 0;
    pageController.jumpToPage(0);
  }
}
