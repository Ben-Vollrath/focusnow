import 'package:challenge_repository/challenge.dart';
import 'package:challenge_repository/challenge_progress.dart';
import 'package:flutter/material.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:focusnow/ui/widgets/duration_text.dart';
import 'package:focusnow/ui/widgets/flat_container.dart';
import 'package:focusnow/ui/widgets/rounded_progress_indicator.dart';
import 'package:focusnow/ui/widgets/xp_badge.dart';

class ChallengeTile extends StatelessWidget {
  final ChallengeWithProgress entry;

  const ChallengeTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final challenge = entry.challenge;
    final progress = entry.progress;

    return FlatContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    challenge.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  challenge.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              //Add badge to show xp gain
              XpBadge(text: '${challenge.reward_xp} XP')
            ],
          ),
          const SizedBox(height: 6),
          if (progress != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundedProgressIndicator(
                  progress: progress.progress,
                  fullAmount: challenge.condition_amount,
                  textLeft: challenge.description,
                  textRight: ChallengeProgressText(
                    progress: progress,
                    challenge: challenge,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          if (progress == null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundedProgressIndicator(
                  progress: 0,
                  fullAmount: challenge.condition_amount,
                  textLeft: challenge.description,
                  textRight: Text(
                    'Locked',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(100)),
                  ),
                  textColor:
                      Theme.of(context).colorScheme.onSurface.withAlpha(100),
                  backgroundColor:
                      Theme.of(context).colorScheme.onSurface.withAlpha(100),
                ),
                const SizedBox(height: 4),
              ],
            ),
        ],
      ),
    );
  }
}

class ChallengeProgressText extends StatelessWidget {
  final ChallengeProgress progress;
  final Challenge challenge;

  const ChallengeProgressText({
    super.key,
    required this.progress,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface.withAlpha(200);
    final isDone = progress.progress >= challenge.condition_amount;

    if (isDone) {
      return const Text('Done');
    }

    return switch (challenge.category) {
      ChallengeCategory.total_hours => Row(
          children: [
            DurationText(
              minutes: progress.progress,
              showUnit: true,
              showUnitShort: true,
              style: TextStyle(fontSize: 12, color: color),
            ),
            Text(' / ', style: TextStyle(fontSize: 12, color: color)),
            DurationText(
              minutes: challenge.condition_amount,
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ),
      _ => Text(
          '${progress.progress} / ${challenge.condition_amount}',
          style: TextStyle(fontSize: 12, color: color),
        ),
    };
  }
}
