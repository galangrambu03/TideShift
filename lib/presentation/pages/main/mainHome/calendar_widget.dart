import 'package:ecomagara/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'calendar_controller.dart';

class KalenderBergambar extends StatelessWidget {
  final controller = Get.find<CalendarController>();

  KalenderBergambar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top bar: month title + navigation arrows
        Obx(() {
          final month = controller.getMonthFromIndex(
            controller.currentPageIndex.value,
          );
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.textGrey,
                ),
                onPressed: () {
                  controller.pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              Text(
                DateFormat.yMMMM().format(month).toUpperCase(),
                style: const TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textGrey,
                ),
                onPressed: () {
                  controller.pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          );
        }),

        // Calendar section
        SizedBox(
          height: 410,
          child: PageView.builder(
            reverse: true,
            controller: controller.pageController,
            itemCount: 4,
            onPageChanged: (index) => controller.currentPageIndex.value = index,
            itemBuilder: (context, index) {
              final month = controller.getMonthFromIndex(index);
              final days = controller.generateDaysForMonth(month);

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildWeekHeaders(),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: _calculateGridHeight(days.length),
                        child: _buildCalendarGrid(days),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Builds the week headers (S, M, T, W, T, F, S)
  Widget _buildWeekHeaders() {
    const headers = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            headers
                .map(
                  (h) => Text(h, style: TextStyle(color: AppColors.textGrey)),
                )
                .toList(),
      ),
    );
  }

  // Calendar grid builder
  // : Generates a grid of days for the current month
  Widget _buildCalendarGrid(List<DateTime?> days) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, i) => _buildDayCell(days[i]),
    );
  }

  // Calculates the height of the grid based on the number of weeks in the month
  double _calculateGridHeight(int totalDays) {
    int rowCount = (totalDays / 7).ceil(); // total rows needed (week)
    const double cellHeight = 48;
    const double spacing = 4;
    return (rowCount * cellHeight) + ((rowCount - 1) * spacing);
  }

  // Builds a single day cell
  // : Displays the day number or an image if data exists for that day
  Widget _buildDayCell(DateTime? day) {
    if (day == null) return const SizedBox();

    final dateKey = DateTime(day.year, day.month, day.day);
    final today = DateTime.now();
    final isToday = controller.isSameDay(day, controller.today);
    final isFuture = day.isAfter(DateTime(today.year, today.month, today.day));

    return Obx(() {
      final level = controller.data[dateKey];
      final asset = controller.getAsset(level);

      final isClickable = level != null; // only clickable if there's data

      final child = Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(6),
        decoration:
            isToday
                ? BoxDecoration(
                  color: AppColors.button1dark,
                  borderRadius: BorderRadius.circular(6),
                )
                : null,
        child:
            asset != null
                ? Image.asset(asset, height: 36, width: 36, fit: BoxFit.contain)
                : Text(
                  "${day.day}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color:
                        isToday
                            ? Colors.white
                            : (isFuture ? Colors.grey : Colors.black),
                  ),
                ),
      );

      // Date is clickable only if it has data
      if (isClickable) {
        return GestureDetector(
          onTap: () {
            print("Selected date with data: ${day.toLocal()}");
          },
          child: child,
        );
      }

      return child;
    });
  }
  
  // Show the the history detail (Total carbon, carbon per category, Island type)
  void showDetailHistory() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.background, // warna latar belakang popup
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              ],
            ),
          ),
        ),
      ),
    );
  }
}
