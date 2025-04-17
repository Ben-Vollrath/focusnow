import 'package:flutter/material.dart';

class RoundedProgressIndicator extends StatelessWidget {
  final int progress;
  final int fullAmount;
  final String textLeft;
  final Widget textRight;
  const RoundedProgressIndicator(
      {super.key,
      required this.progress,
      required this.fullAmount,
      required this.textLeft,
      required this.textRight});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              textLeft,
              style: const TextStyle(),
            ),
            textRight,
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: (progress / fullAmount).clamp(0.0, 1.0),
            backgroundColor:
                Theme.of(context).colorScheme.onSurface.withAlpha(200),
            color: progress == fullAmount
                ? Color(0xFF3FBF7F)
                : Theme.of(context).colorScheme.primary,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
