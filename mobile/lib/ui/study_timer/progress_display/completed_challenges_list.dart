import 'package:flutter/material.dart';
import 'package:challenge_repository/challenge.dart';
import 'package:focusnow/ui/widgets/xp_badge.dart';

class CompletedChallengesList extends StatefulWidget {
  final List<Challenge> challenges;

  const CompletedChallengesList({
    super.key,
    required this.challenges,
  });

  @override
  State<CompletedChallengesList> createState() =>
      _CompletedChallengesListState();
}

class _CompletedChallengesListState extends State<CompletedChallengesList>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Automatically expand when new challenges come in
    if (widget.challenges.isNotEmpty) {
      _controller.forward();
      _expanded = true;
    }
  }

  @override
  void didUpdateWidget(covariant CompletedChallengesList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.challenges.isNotEmpty && !_expanded) {
      _controller.forward();
      _expanded = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.challenges.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Completed Challenges",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.challenges.map((challenge) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${challenge.icon} ${challenge.name}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    XpBadge(text: "${challenge.reward_xp} XP")
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
