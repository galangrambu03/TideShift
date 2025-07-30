import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CarbonDonutChart extends StatefulWidget {
  final Map<String, double> data;

  const CarbonDonutChart({super.key, required this.data});

  @override
  State<CarbonDonutChart> createState() => _CarbonDonutChartState();
}

class _CarbonDonutChartState extends State<CarbonDonutChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.data.values.fold(0.0, (sum, value) => sum + value);

    final sections = widget.data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final key = entry.value.key;
      final value = entry.value.value;

      final percentage = total == 0 ? 0 : (value / total) * 100;
      final isTouched = index == touchedIndex;
      final color = _getCategoryColor(key);

      return PieChartSectionData(
        color: color,
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        radius: isTouched ? 70 : 60, // perbesar jika disentuh
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        setState(() {
                          touchedIndex = -1;
                        });
                        return;
                      }
                      setState(() {
                        touchedIndex =
                            response.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                ),
              ),
              if (touchedIndex != -1)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.data.keys.elementAt(touchedIndex),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      '${widget.data.values.elementAt(touchedIndex).toStringAsFixed(2)} kg',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: widget.data.keys.map((category) {
            final color = _getCategoryColor(category);
            return GestureDetector(
              onTap: () {
                final index = widget.data.keys.toList().indexOf(category);
                setState(() {
                  touchedIndex = index;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Transport':
        return Colors.blue;
      case 'Food':
        return Colors.green;
      case 'Energy':
        return Colors.orange;
      case 'Lifestyle':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
