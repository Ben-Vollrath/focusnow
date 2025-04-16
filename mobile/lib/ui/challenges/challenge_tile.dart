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
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                challenge.icon,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  challenge.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (progress == null)
                const Icon(Icons.lock_outline, color: Colors.grey),
              if (progress?.completed == true)
                const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            challenge.description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          if (progress != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: (progress.progress / challenge.condition_amount)
                      .clamp(0.0, 1.0),
                  backgroundColor: Colors.grey.shade300,
                  color: progress.completed
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                Text('${progress.progress} / ${challenge.condition_amount}',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          if (progress == null)
            const Text('Locked', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
