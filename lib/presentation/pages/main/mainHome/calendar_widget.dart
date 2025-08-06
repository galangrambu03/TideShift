import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/datasource/models/DailyCarbonLogModel.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/carbonUnit_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/carbonLog_controller.dart';
import 'package:ecomagara/presentation/widgets/donutChart.dart';
import 'package:ecomagara/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'calendar_controller.dart';

class KalenderBergambar extends StatefulWidget {
  KalenderBergambar({super.key});

  @override
  State<KalenderBergambar> createState() => _KalenderBergambarState();
}

class _KalenderBergambarState extends State<KalenderBergambar> {
  final controller = Get.find<CalendarController>();

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
  Widget _buildDayCell(DateTime? day) {
    if (day == null) return const SizedBox();

    final today = DateTime.now();
    final isToday = controller.isSameDay(day, controller.today);
    final isFuture = day.isAfter(DateTime(today.year, today.month, today.day));

    return Obx(() {
      // Get log data for this specific date
      final logForDate = controller.getLogForDate(day);
      final carbonLevel =
          logForDate?.carbonLevel; // Use carbonLevel from the model
      final asset = controller.getAsset(carbonLevel);

      final hasData =
          logForDate != null; // Check if there's log data for this date

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
            asset != null && hasData
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
      if (hasData) {
        return GestureDetector(
          onTap: () {
            print("Selected date with data: ${day.toLocal()}");
            showDetailHistory(logForDate);
          },
          child: child,
        );
      }

      return child;
    });
  }

  // Show the history detail (Total carbon, carbon per category, Island type)
  void showDetailHistory(CarbonLogModel? log) {
    if (log == null) return;

    final carbonLogController = Get.find<DailyCarbonLogController>();
    final carbonUnitController = Get.find<CarbonUnitController>();

    final date = DateFormat('d MMMM yyyy').format(DateTime.parse(log.logDate));
    final totalCarbon = log.totalCarbon.toStringAsFixed(1);

    // Load humorText berdasarkan totalCarbon
    carbonUnitController.loadHumor(log.totalCarbon);

    // Hitung data distribusi kategori karbon
    final categoryData = carbonLogController.calculateCarbonDistribution(log);

    final total = categoryData.values.fold(0.0, (a, b) => a + b);
    final Map<String, String> labelData = categoryData.map(
      (key, value) =>
          MapEntry(key, "${((value / total) * 100).toStringAsFixed(1)}%"),
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            maxWidth: 360,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // title bar
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Color(0xFF4E6656)),
                      onPressed: () => Get.back(),
                    ),
                    Text(
                      "Daily Carbon History",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4E6656),
                      ),
                    ),
                  ],
                ),
                Text(
                  date.toUpperCase(),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 15),

                Flexible(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // container gambar + total carbon
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                'assets/images/islandsImages/island${controller.islandTheme}${log.islandPath}.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Your Total Carbon",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.surface,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "CO₂ $totalCarbon kg",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.surface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 15),

                        Image.asset(
                          'assets/images/decorationImages/mascotHappy.png',
                          scale: 17,
                        ),
                        SizedBox(height: 4),
                        Obx(
                          () => Text(
                            carbonUnitController.humorText.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),

                        SizedBox(height: 40),

                        CarbonDonutChart(data: categoryData),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
