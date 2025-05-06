import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/ui/stats/level_box.dart';
import 'package:focusnow/ui/stats/study_chart.dart';
import 'package:focusnow/ui/stats/todays_achievement.dart';
import 'package:focusnow/ui/stats/utils.dart';
import 'package:focusnow/ui/widgets/icon_badge.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  void initState() {
    super.initState();
    AnalyticsRepository().logScreen("stats_page");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<StatsBloc>().add(ReloadUserStats());
            AnalyticsRepository().logEvent("stats_page_refreshed");
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
    return IconBadge(
      icon: const Icon(Icons.local_fire_department,
          size: 16, color: Colors.orange),
      text: "$streak",
      tooltipMessage: "Current Streak",
    );
  }
}
