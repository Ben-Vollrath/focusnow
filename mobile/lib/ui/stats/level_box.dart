import 'package:flutter/material.dart';
import 'package:focusnow/ui/stats/utils.dart';
import 'package:focusnow/ui/widgets/flat_container.dart';
import 'package:focusnow/ui/widgets/rounded_progress_indicator.dart';

class LevelBox extends StatelessWidget {
  final String levelIcon;
  final int level;
  final String levelName;
  final int xp;
  final int xpToNext;
  final int progress;
  final int full_amount;
  final bool showShareButton;

  const LevelBox(
      {required this.levelIcon,
      required this.level,
      required this.levelName,
      required this.xp,
      required this.xpToNext,
      required this.progress,
      required this.full_amount,
      this.showShareButton = true});

  @override
  Widget build(BuildContext context) {
    return FlatContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          levelName,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (showShareButton)
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () =>
                                captureAndShareStatsImage(context: context),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
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
