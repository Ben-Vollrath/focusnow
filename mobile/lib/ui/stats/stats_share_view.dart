import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/goal/goal_bloc.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/ui/stats/goal_box.dart';
import 'package:focusnow/ui/stats/level_box.dart';
import 'package:focusnow/ui/stats/stats_page.dart';
import 'package:focusnow/ui/stats/study_chart.dart';
import 'package:focusnow/ui/stats/todays_achievement.dart';
import 'package:focusnow/ui/stats/utils.dart';
import 'package:stats_repository/daily_study_data.dart';
import 'package:stats_repository/user_stats.dart';

class StatsShareView extends StatelessWidget {
  const StatsShareView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.translate(
                  offset: Offset(0, -4),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      'assets/icon_round.png',
                      height: 80,
                    ),
                  ),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AutoSizeText(
                      'FocusNow',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Spacer(),
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
                    showShareButton: false,
                  ),
                  const SizedBox(height: 16),
                  StudyChart(weeklyData: state.weeklyStudyData),
                  const SizedBox(height: 16),
                  TodaysAchievements(
                    todaysStudyTime: getTodayMinutes(state.weeklyStudyData),
                    todaysSessions: getTodaySessions(state.weeklyStudyData),
                  ),
                  const SizedBox(height: 16),
                  if (context.read<GoalBloc>().state.status ==
                          GoalStatus.loaded &&
                      context.read<GoalBloc>().state.goal != null)
                    GoalBox(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
