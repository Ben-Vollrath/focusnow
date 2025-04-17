import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/ui/stats/goal/goal_box.dart';
import 'package:focusnow/ui/widgets/duration_text.dart';
import 'package:focusnow/ui/widgets/rounded_progress_indicator.dart';
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
                _LevelBox(
                  levelIcon: userStats.levelIcon,
                  level: userStats.level,
                  levelName: userStats.levelName,
                  xp: userStats.xp,
                  xpToNext: xpToNext,
                  progress: userStats.xp,
                  full_amount: xpToNext,
                ),
                const SizedBox(height: 24),
                _StudyChart(weeklyData: state.weeklyStudyData),
                const SizedBox(height: 24),
                _TodaysAchievements(
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

  int _getTodayMinutes(List<Map<String, dynamic>> weeklyData) {
    final today = DateTime.now();
    final todayStr = DateTime(today.year, today.month, today.day)
        .toIso8601String()
        .split('T')
        .first;
    final todayEntry = weeklyData.firstWhere(
      (e) => e['study_date'] == todayStr,
      orElse: () => {},
    );
    return (todayEntry['total_study_time'] ?? 0);
  }

  int _getTodaySessions(List<Map<String, dynamic>> weeklyData) {
    final today = DateTime.now();
    final todayStr = DateTime(today.year, today.month, today.day)
        .toIso8601String()
        .split('T')
        .first;
    final todayEntry = weeklyData.firstWhere(
      (e) => e['study_date'] == todayStr,
      orElse: () => {},
    );
    return todayEntry['total_study_sessions'] ?? 0;
  }
}

class _LevelBox extends StatelessWidget {
  final String levelIcon;
  final int level;
  final String levelName;
  final int xp;
  final int xpToNext;
  final int progress;
  final int full_amount;

  const _LevelBox({
    required this.levelIcon,
    required this.level,
    required this.levelName,
    required this.xp,
    required this.xpToNext,
    required this.progress,
    required this.full_amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(levelIcon, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    levelName,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: Text(
                        'Level $level',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          RoundedProgressIndicator(
            progress: progress,
            fullAmount: full_amount,
            textLeft: 'Progress to Level ${level + 1}',
            textRight: Text('$xp / $xpToNext XP',
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(200))),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

class _StudyChart extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyData;

  const _StudyChart({required this.weeklyData});

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

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
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

class _TodaysAchievements extends StatelessWidget {
  final int todaysSessions;
  final int todaysStudyTime;

  const _TodaysAchievements({
    required this.todaysSessions,
    required this.todaysStudyTime,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s Achievements', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  color: Theme.of(context).colorScheme.primary,
                  label: 'Duration',
                  value: DurationText(
                      minutes: todaysStudyTime,
                      style: textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  color: Theme.of(context).colorScheme.primary,
                  label: 'Sessions',
                  value: Text(
                    '$todaysSessions',
                    style: textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<ChallengeBloc, ChallengeState>(
            builder: (context, state) {
              if (state.status == Status.loading ||
                  state.status == Status.initial) {
                return const SizedBox.shrink();
              }

              final today = DateTime.now();
              final todayStr = DateTime(today.year, today.month, today.day)
                  .toIso8601String()
                  .split('T')
                  .first;

              final todayCompleted = state.challenges.where((entry) {
                final isCompleted = entry.progress?.completed ?? false;
                final completedToday = entry.progress?.last_updated
                        .toIso8601String()
                        .startsWith(todayStr) ??
                    false;
                return isCompleted && completedToday;
              }).toList();

              if (todayCompleted.isEmpty) {
                return Text(
                  'No challenges completed today.',
                  style: textTheme.bodySmall?.copyWith(color: Colors.white38),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Completed Challenges', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...todayCompleted.map((c) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Text(c.challenge.icon,
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                c.challenge.name,
                                style: textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${c.challenge.reward_xp} XP',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Color color;
  final String label;
  final Widget value;

  const _StatCard({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(label, style: textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: 8),
        value
      ],
    );
  }
}
