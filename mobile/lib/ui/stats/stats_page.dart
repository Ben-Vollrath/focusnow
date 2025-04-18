import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/ui/stats/goal_box.dart';
import 'package:focusnow/ui/stats/level_box.dart';
import 'package:focusnow/ui/stats/study_chart.dart';
import 'package:focusnow/ui/stats/todays_achievement.dart';
import 'package:stats_repository/daily_study_data.dart';
import 'package:stats_repository/stats_repository.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StatsBloc(statsRepository: StatsRepository())..add(LoadStats()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stats'),
          scrolledUnderElevation: 0.0,
        ),
        body: BlocBuilder<StatsBloc, StatsState>(
          builder: (context, state) {
            if (state.status == StatsStatus.loading ||
                state.status == StatsStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == StatsStatus.failure) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            }

            final userStats = state.userStats!;
            final xpToNext =
                userStats.xpToNext ?? userStats.xp; // fallback for max level

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                LevelBox(
                  levelIcon: userStats.levelIcon,
                  level: userStats.level,
                  levelName: userStats.levelName,
                  xp: userStats.xp,
                  xpToNext: xpToNext,
                  progress: userStats.xp,
                  full_amount: xpToNext,
                ),
                const SizedBox(height: 24),
                StudyChart(weeklyData: state.weeklyStudyData),
                const SizedBox(height: 24),
                TodaysAchievements(
                  todaysStudyTime: _getTodayMinutes(state.weeklyStudyData),
                  todaysSessions: _getTodaySessions(state.weeklyStudyData),
                ),
                const SizedBox(height: 24),
                GoalBox(),
              ],
            );
          },
        ),
      ),
    );
  }

  int _getTodayMinutes(List<DailyStudyData> weeklyData) {
    final today = DateTime.now();
    final todayStr = DateTime(today.year, today.month, today.day)
        .toIso8601String()
        .split('T')
        .first;

    final todayEntry = weeklyData.firstWhere(
      (e) => e.studyDate == todayStr,
      orElse: () => DailyStudyData(
        studyDate: todayStr,
        totalStudyTime: 0,
        totalStudySessions: 0,
        streakDay: 0,
      ),
    );

    return todayEntry.totalStudyTime ?? 0;
  }

  int _getTodaySessions(List<DailyStudyData> weeklyData) {
    final today = DateTime.now();
    final todayStr = DateTime(today.year, today.month, today.day)
        .toIso8601String()
        .split('T')
        .first;

    final todayEntry = weeklyData.firstWhere(
      (e) => e.studyDate == todayStr,
      orElse: () => DailyStudyData(
        studyDate: todayStr,
        totalStudyTime: 0,
        totalStudySessions: 0,
        streakDay: 0,
      ),
    );

    return todayEntry.totalStudySessions ?? 0;
  }
}
