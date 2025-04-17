import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:focusnow/ui/widgets/duration_text.dart';

class TodaysAchievements extends StatelessWidget {
  final int todaysSessions;
  final int todaysStudyTime;

  const TodaysAchievements({
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
