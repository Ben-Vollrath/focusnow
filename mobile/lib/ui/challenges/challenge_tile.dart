import 'package:flutter/material.dart';
import 'package:challenge_repository/challenge_repository.dart';

class ChallengeTile extends StatelessWidget {
  final ChallengeWithProgress entry;

  const ChallengeTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final challenge = entry.challenge;
    final progress = entry.progress;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
      padding: const EdgeInsets.all(12),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${challenge.reward_xp} XP',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                challenge.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (progress != null)
                Text(
                  progress.progress != challenge.condition_amount
                      ? '${progress.progress} / ${challenge.condition_amount}'
                      : 'Done',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (progress != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: (progress.progress / challenge.condition_amount)
                        .clamp(0.0, 1.0),
                    backgroundColor:
                        Theme.of(context).colorScheme.onSurface.withAlpha(200),
                    color: progress.completed
                        ? Color(0xFF3FBF7F)
                        : Theme.of(context).colorScheme.primary,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          if (progress == null)
            Text('Locked',
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(150))),
        ],
      ),
    );
  }
}
