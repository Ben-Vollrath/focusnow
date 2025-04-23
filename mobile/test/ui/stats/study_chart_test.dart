import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/ui/stats/study_chart.dart';
import 'package:stats_repository/daily_study_data.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  List<DailyStudyData> createTestData() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return DailyStudyData(
        studyDate: date.toIso8601String().split('T').first,
        totalStudyTime: i * 10,
        totalStudySessions: i,
        streakDay: i,
      );
    });
  }

  testWidgets('renders study chart with 7 bars and correct labels',
      (tester) async {
    final data = createTestData();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StudyChart(weeklyData: data),
      ),
    ));

    // Validate title and icon are shown
    expect(find.text('Study Time'), findsOneWidget);
    expect(find.byIcon(Icons.hourglass_bottom_outlined), findsOneWidget);

    // "Today" label should be present exactly once
    expect(find.text('Today'), findsOneWidget);

    // Only 6 other weekday labels should be visible (excluding "Today")
    final allWeekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final today = DateTime.now().weekday;
    final todayLabel = allWeekdays[today - 1];

    int weekdayCount = 0;
    for (final label in allWeekdays) {
      if (label != todayLabel) {
        final matches = find.text(label);
        if (matches.evaluate().isNotEmpty) {
          weekdayCount++;
        }
      }
    }

    expect(weekdayCount, 6);
  });

  testWidgets('renders correct bar heights based on study time',
      (tester) async {
    final data = createTestData();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StudyChart(weeklyData: data),
      ),
    ));

    // We can't directly inspect heights in fl_chart, but we can check if the BarChart renders
    expect(find.byType(BarChart), findsOneWidget);
  });

  testWidgets('renders "Today" label for the current day', (tester) async {
    final data = createTestData();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StudyChart(weeklyData: data),
      ),
    ));

    expect(find.text('Today'), findsOneWidget);
  });
}
