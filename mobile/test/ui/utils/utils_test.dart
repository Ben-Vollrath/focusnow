import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/ui/stats/utils.dart';
import 'package:intl/intl.dart';
import 'package:stats_repository/daily_study_data.dart';

void main() {
  group('getTodayMinutes', () {
    test('returns correct study time for today', () {
      final today = DateTime.now().toIso8601String().split('T').first;
      final data = [
        DailyStudyData(
          studyDate: today,
          totalStudyTime: 42,
          totalStudySessions: 2,
          streakDay: 3,
        ),
        DailyStudyData(
          studyDate: DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String()
              .split('T')
              .first,
          totalStudyTime: 30,
          totalStudySessions: 1,
          streakDay: 1,
        ),
      ];

      expect(getTodayMinutes(data), 42);
    });

    test('returns 0 if no entry for today', () {
      final yesterday = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 1)));
      final data = [
        DailyStudyData(
          studyDate: yesterday,
          totalStudyTime: 60,
          totalStudySessions: 3,
          streakDay: 2,
        ),
      ];

      expect(getTodayMinutes(data), 0);
    });
  });

  group('getTodaySessions', () {
    test('returns correct session count for today', () {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final data = [
        DailyStudyData(
          studyDate: today,
          totalStudyTime: 30,
          totalStudySessions: 4,
          streakDay: 2,
        ),
        DailyStudyData(
          studyDate: DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String()
              .split('T')
              .first,
          totalStudyTime: 30,
          totalStudySessions: 1,
          streakDay: 1,
        ),
      ];

      expect(getTodaySessions(data), 4);
    });

    test('returns 0 if no entry for today', () {
      final pastDate = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 3)));
      final data = [
        DailyStudyData(
          studyDate: pastDate,
          totalStudyTime: 50,
          totalStudySessions: 3,
          streakDay: 0,
        ),
      ];

      expect(getTodaySessions(data), 0);
    });
  });

  group('getCurrentStreak', () {
    test('returns streak from today if present', () {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final data = [
        DailyStudyData(
          studyDate: today,
          totalStudyTime: 90,
          totalStudySessions: 5,
          streakDay: 4,
        ),
      ];

      expect(getCurrentStreak(data), 4);
    });

    test('returns streak from yesterday if today missing', () {
      final yesterday = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 1)));
      final data = [
        DailyStudyData(
          studyDate: yesterday,
          totalStudyTime: 60,
          totalStudySessions: 3,
          streakDay: 2,
        ),
      ];

      expect(getCurrentStreak(data), 2);
    });

    test('returns 0 if today and yesterday are missing', () {
      final twoDaysAgo = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 2)));
      final data = [
        DailyStudyData(
          studyDate: twoDaysAgo,
          totalStudyTime: 80,
          totalStudySessions: 4,
          streakDay: 3,
        ),
      ];

      expect(getCurrentStreak(data), 0);
    });
  });
}
