import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:focusnow/ui/widgets/duration_text.dart';
import 'package:focusnow/ui/widgets/flat_container.dart';
import 'package:focusnow/ui/widgets/icon_badge.dart';

class LeaderboardTile extends StatelessWidget {
  final int rank;
  final String userName;
  final int studyMinutes;
  final int studySessions;
  final bool isCurrentUser;
  const LeaderboardTile(
      {super.key,
      required this.rank,
      required this.userName,
      required this.studyMinutes,
      required this.studySessions,
      required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return FlatContainer(
        child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("#$rank", style: const TextStyle(fontSize: 24)),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(userName,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                _buildRankIcon(rank),
                if (isCurrentUser)
                  IconBadge(
                      icon: const Icon(Icons.person_sharp,
                          size: 16, color: Colors.orange),
                      text: "You",
                      tooltipMessage: "")
              ],
            ),
          ],
        ),
        Spacer(),
        Column(
          children: [
            IconBadge(
                icon: const Icon(Icons.timelapse_outlined,
                    size: 16, color: Colors.orange),
                text: "$studySessions",
                tooltipMessage: "Study Sessions"),
            const SizedBox(height: 6),
            IconBadge(
                icon: const Icon(Icons.calendar_month_outlined,
                    size: 16, color: Colors.orange),
                text: formatDuration(studyMinutes, showUnitShort: true),
                tooltipMessage: "Time Studied")
          ],
        ),
      ],
    ));
  }

  Widget _buildRankIcon(int rank) {
    switch (rank) {
      case 1:
        return const Icon(Icons.emoji_events, color: Colors.yellow);
      case 2:
        return const Icon(Icons.emoji_events, color: Colors.grey);
      case 3:
        return const Icon(Icons.emoji_events, color: Colors.brown);
      default:
        return const SizedBox.shrink();
    }
  }
}
