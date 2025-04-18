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
      child: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Stats'),
                  StreakBadge(streak: _getCurrentStreak(state.weeklyStudyData)),
                ],
              ),
              scrolledUnderElevation: 0.0,
            ),
            body: Builder(
              builder: (context) {
                if (state.status == StatsStatus.loading ||
                    state.status == StatsStatus.initial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == StatsStatus.failure) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                }

                final userStats = state.userStats!;
                final xpToNext = userStats.xpToNext ??
                    userStats.xp; // fallback for max level

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
          );
        },
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

  int _getCurrentStreak(List<DailyStudyData> weeklyData) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Convert studyData to a map for fast lookup
    final studyMap = {
      for (final data in weeklyData)
        DateTime.parse(data.studyDate): data.totalStudyTime ?? 0
    };

    int streak = 0;

    // Check consecutive days backwards from today
    for (int i = 0; i < 7; i++) {
      final date = todayDate.subtract(Duration(days: i));
      final studyTime = studyMap[date] ?? 0;

      if (studyTime > 0) {
        streak++;
      } else {
        break; // streak ends
      }
    }

    return streak;
  }
}

class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Tooltip(
      message: 'Current Streak',
      showDuration: const Duration(seconds: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_fire_department,
                size: 16, color: Colors.orange),
            const SizedBox(width: 4),
            Text('$streak',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
