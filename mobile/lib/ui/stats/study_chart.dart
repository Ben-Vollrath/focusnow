import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:focusnow/ui/widgets/duration_text.dart';
import 'package:focusnow/ui/widgets/flat_container.dart';

class StudyChart extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyData;

  const StudyChart({required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekDates = List.generate(
      7,
      (i) => DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i)),
    );

    final studyMap = {
      for (var e in weeklyData) e['study_date']: e['total_study_time']
    };

    final barGroups = <BarChartGroupData>[];
    final labels = <String>[];

    for (var i = 0; i < weekDates.length; i++) {
      final date = weekDates[i];
      final dateStr = date.toIso8601String().split('T').first;
      final minutes = (studyMap[dateStr] ?? 0);

      final isToday = date.day == now.day &&
          date.month == now.month &&
          date.year == now.year;

      labels.add(isToday ? 'Today' : _weekdayLabel(date.weekday));

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: minutes.toDouble(),
              width: 14,
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return FlatContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Study Time'),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30, // <- increase this from 28
                      getTitlesWidget: (value, _) {
                        return Text(
                          formatDuration(value.toInt(), showUnitShort: true),
                          textAlign:
                              TextAlign.right, // <- align right to avoid wrap
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, _) => Text(
                        labels[val.toInt()],
                      ),
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(150), // subtle line color
                      strokeWidth: 1,
                      dashArray: [4, 4], // <-- this makes it dotted
                    );
                  },
                ),
                barGroups: barGroups,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 12,
                    getTooltipColor: (_) =>
                        Theme.of(context).colorScheme.surfaceContainerLowest,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final minutes = rod.toY.toInt();
                      return BarTooltipItem(
                        formatDuration(minutes),
                        TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _weekdayLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}
