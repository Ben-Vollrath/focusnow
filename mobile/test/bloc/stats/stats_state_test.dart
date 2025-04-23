// ignore_for_file: prefer_const_constructors
import 'package:focusnow/bloc/goal/goal_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:goal_repository/goal.dart';
import 'package:stats_repository/daily_study_data.dart';
import 'package:stats_repository/level.dart';
import 'package:stats_repository/user_stats.dart';

void main() {
  group('StatsState', () {
    test('copywith works correclty', () {
      final userStats = UserStats(
          level: 1,
          xp: 1,
          xpToNext: 2,
          levelName: "levelName",
          levelIcon: "levelIcon",
          totalStudyTime: 1,
          totalStudySessions: 1);
      final levels = [
        Level(level: 1, name: "name", icon: "icon", xpRequired: 10)
      ];
      final weeklyStudyData = [
        DailyStudyData(
            studyDate: "2024-01-01",
            totalStudyTime: 1,
            totalStudySessions: 1,
            streakDay: 1)
      ];

      final sourceState = StatsState();
      final newState = sourceState.copyWith(
        status: StatsStatus.success,
        userStats: userStats,
        levels: levels,
        weeklyStudyData: weeklyStudyData,
        errorMessage: "test",
      );

      expect(newState.userStats, userStats);
      expect(newState.status, StatsStatus.success);
      expect(newState.levels, levels);
      expect(newState.weeklyStudyData, weeklyStudyData);
      expect(newState.errorMessage, "test");
    });
  });
}
