import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/goal/goal_bloc.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/ui/stats/goal_box.dart';
import 'package:focusnow/ui/stats/level_box.dart';
import 'package:focusnow/ui/stats/study_chart.dart';
import 'package:focusnow/ui/stats/todays_achievement.dart';
import 'package:focusnow/ui/stats/utils.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<StatsBloc>().add(ReloadUserStats());
            context.read<GoalBloc>().add(LoadGoal());
          },
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Stats'),
                  StreakBadge(streak: getCurrentStreak(state.weeklyStudyData)),
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
                    const SizedBox(height: 16),
                    StudyChart(weeklyData: state.weeklyStudyData),
                    const SizedBox(height: 16),
                    TodaysAchievements(
                      todaysStudyTime: getTodayMinutes(state.weeklyStudyData),
                      todaysSessions: getTodaySessions(state.weeklyStudyData),
                    ),
                    const SizedBox(height: 16),
                    GoalBox(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
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
