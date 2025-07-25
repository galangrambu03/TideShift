import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarController extends GetxController {
  // TODO: Implement dynamic data fetching for calendar
  // DEBUG: Reactive map storing a date and its corresponding island level
  final data =
      <DateTime, int>{
        DateTime(2025, 7, 2): 1,
        DateTime(2025, 7, 8): 3,
        DateTime(2025, 7, 15): 2,
        DateTime(2025, 7, 18): 0,
      }.obs;

  // PageController to manage horizontal swiping between months
  final pageController = PageController(initialPage: 0);

  final currentPageIndex = 0.obs;

  // Store today's date
  final today = DateTime.now();

  // Get the month based on index (0 = current month, 1 = previous month, etc.)
  DateTime getMonthFromIndex(int index) {
    return DateTime(today.year, today.month - index);
  }

  // Return the asset path based on the level value
  String? getAsset(int? level) {
    if (level == null || level < 0 || level > 4) return null;
    return 'assets/images/islandsImages/island$level.png';
  }

  // Generate a full list of days for a given month, including empty slots for alignment
  List<DateTime?> generateDaysForMonth(DateTime month) {
    // First and last day of the month
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    final days = <DateTime?>[];

    // Calculate how many empty boxes before the first day to align the grid
    final weekdayOffset = firstDay.weekday % 7;
    for (int i = 0; i < weekdayOffset; i++) {
      days.add(null); // Add null for empty slots before the first day
    }

    for (int i = 1; i <= lastDay.day; i++) {
      final date = DateTime(month.year, month.month, i);
      days.add(date); // Show all dates, including future ones
    }

    // Add trailing nulls so total items are divisible by 7 (for complete weeks)
    while (days.length % 7 != 0) {
      days.add(null);
    }

    return days;
  }

  // Check if two dates are exactly the same (ignoring time)
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
