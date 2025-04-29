import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:focusnow/ui/study_timer/progress_display/animated_level_bar.dart';
import 'package:focusnow/ui/study_timer/progress_display/completed_challenges_list.dart';
import 'package:focusnow/ui/widgets/flat_container.dart';
import 'package:stats_repository/user_stats.dart';
import 'package:challenge_repository/challenge.dart';

class ProgressDisplay extends StatefulWidget {
  final Function() onLevelUp;

  const ProgressDisplay({super.key, required this.onLevelUp});

  @override
  State<ProgressDisplay> createState() => _ProgressDisplayState();
}

class _ProgressDisplayState extends State<ProgressDisplay>
    with AutomaticKeepAliveClientMixin {
  UserStats? _currentStats;
  UserStats? _previousStats;
  List<Challenge> _recentlyCompletedChallenges = [];
  bool _visible = false;
  Timer? _hideTimer;
  bool _challengesInitialized = false;
  bool _statsInitialized = false;
  final List<String> _previousCompletedChallengeIds = [];

  @override
  bool get wantKeepAlive => true;

  void _setVisible() {
    setState(() {
      _visible = true;
    });
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 15), () {
      setState(() {
        _visible = false;
        _recentlyCompletedChallenges = [];
      });
    });
  }

  void _handleStatsUpdate(UserStats? stats) {
    if (stats == null) return;
    setState(() {
      _previousStats = _currentStats;
      _currentStats = stats;

      if (_statsInitialized) {
        _setVisible();
      } else {
        _statsInitialized = true;
      }
    });
  }

  void _handleChallengeUpdate(List<ChallengeWithProgress> challenges) {
    final completedNow = challenges
        .where((c) => c.progress?.completed == true)
        .map((c) => c.challenge)
        .toList();

    if (!_challengesInitialized) {
      // First load: store already completed challenges, don't animate
      _previousCompletedChallengeIds.addAll(completedNow.map((c) => c.id));
      _challengesInitialized = true;
      return;
    }

    final newlyCompleted = completedNow
        .where((c) => !_previousCompletedChallengeIds.contains(c.id))
        .toList();

    if (newlyCompleted.isNotEmpty) {
      setState(() {
        _recentlyCompletedChallenges = newlyCompleted;
        _previousCompletedChallengeIds.addAll(newlyCompleted.map((c) => c.id));
      });
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<StatsBloc, StatsState>(
          listenWhen: (prev, curr) {
            if (curr.status == StatsStatus.loading) return false;
            final a = prev.userStats;
            final b = curr.userStats;
            if (a == null) return true;
            if (b == null) return false;
            return a.xp != b.xp || a.level != b.level;
          },
          listener: (context, state) {
            _handleStatsUpdate(state.userStats);
          },
        ),
        BlocListener<ChallengeBloc, ChallengeState>(
          listenWhen: (prev, curr) {
            if (curr.status == Status.loading) return false;
            return prev.challenges != curr.challenges;
          },
          listener: (context, state) {
            _handleChallengeUpdate(state.challenges);
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {
          setState(() {
            _visible = false;
          });
          AnalyticsRepository().logEvent("progress_display_dismissed");
        },
        child: Visibility(
          visible: _visible,
          child: FlatContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_currentStats != null && _previousStats != null) ...[
                  AnimatedLevelBar(
                    key: ValueKey('${_previousStats!.xp}-${_currentStats!.xp}'),
                    onLevelUp: widget.onLevelUp,
                    previous: _previousStats!,
                    current: _currentStats!,
                  ),
                  const SizedBox(height: 12),
                ],
                CompletedChallengesList(
                  key: ValueKey(_recentlyCompletedChallenges.hashCode),
                  challenges: _recentlyCompletedChallenges,
                ),
                //]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
