import 'package:flutter/material.dart';
import 'package:focusnow/ui/widgets/duration_text.dart';
import 'package:focusnow/ui/widgets/flat_container.dart';
import 'package:focusnow/ui/widgets/rank_display.dart';
import 'package:focusnow/ui/widgets/rounded_progress_indicator.dart';

class GoalLeaderboardTile extends StatelessWidget {
  final String userName;
  final int rank;
  final int currentMinutes;
  final int goalMinutes;
  const GoalLeaderboardTile(
      {super.key,
      required this.userName,
      required this.rank,
      required this.currentMinutes,
      required this.goalMinutes});

  @override
  Widget build(BuildContext context) {
    return FlatContainer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            RankDisplay(rankVal: rank),
            const SizedBox(width: 8),
            Text(userName, style: Theme.of(context).textTheme.titleMedium),
            Spacer(),
            DurationText(
              minutes: currentMinutes,
              showUnit: true,
              showUnitShort: true,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(' / ', style: Theme.of(context).textTheme.titleMedium),
            DurationText(
                minutes: goalMinutes,
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        SizedBox(height: 4),
        RoundedProgressIndicator(
            progress: currentMinutes,
            fullAmount: goalMinutes,
            textLeft: "",
            textRight: SizedBox.shrink())
      ],
    ));
  }
}
