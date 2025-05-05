import 'package:flutter/material.dart';

class RankDisplay extends StatelessWidget {
  final int rankVal;

  const RankDisplay({super.key, required this.rankVal});

  @override
  Widget build(BuildContext context) {
    final rank = RankingExtension.fromRank(rankVal);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: rank.showValue
            ? Text("#$rankVal", style: const TextStyle(fontSize: 24))
            : rank.icon,
      ),
    );
  }
}

enum Ranking {
  first,
  second,
  third,
  other,
}

extension RankingExtension on Ranking {
  static Ranking fromRank(int rank) {
    switch (rank) {
      case 1:
        return Ranking.first;
      case 2:
        return Ranking.second;
      case 3:
        return Ranking.third;
      default:
        return Ranking.other;
    }
  }

  bool get showValue {
    switch (this) {
      case Ranking.first:
      case Ranking.second:
      case Ranking.third:
        return false;
      default:
        return true;
    }
  }

  Icon get icon {
    switch (this) {
      case Ranking.first:
        return const Icon(Icons.emoji_events, color: Colors.amber, size: 24);
      case Ranking.second:
        return const Icon(Icons.emoji_events, color: Colors.grey, size: 24);
      case Ranking.third:
        return const Icon(Icons.emoji_events, color: Colors.brown, size: 24);
      default:
        return const Icon(Icons.star_border);
    }
  }
}
