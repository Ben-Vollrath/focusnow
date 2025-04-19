import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/ui/widgets/rounded_progress_indicator.dart';
import 'package:stats_repository/level.dart';
import 'package:stats_repository/user_stats.dart';

class AnimatedLevelBar extends StatefulWidget {
  final Function() onLevelUp;
  final UserStats previous;
  final UserStats current;

  const AnimatedLevelBar({
    super.key,
    required this.previous,
    required this.current,
    required this.onLevelUp,
  });

  @override
  State<AnimatedLevelBar> createState() => _AnimatedLevelBarState();
}

class _AnimatedLevelBarState extends State<AnimatedLevelBar>
    with TickerProviderStateMixin {
  int _xpProgress = 0;
  Level _currentLevel =
      Level(level: 0, name: 'Unknown', icon: '❓', xpRequired: 1000);
  late List<Level> _levels;

  @override
  void initState() {
    super.initState();
    final stats = context.read<StatsBloc>().state;
    _levels = stats.levels ?? [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLevelAnimation();
    });
  }

  void _startLevelAnimation() {
    final fromLevel = widget.previous.level;
    final toLevel = widget.current.level;

    // All levels from current up to final (inclusive of final level)
    final levelsInRange = _levels
        .where((lvl) => lvl.level >= fromLevel && lvl.level <= toLevel)
        .toList();

    _animateThroughLevels(levelsInRange);
  }

  void _animateThroughLevels(List<Level> levels) async {
    for (int i = 0; i < levels.length; i++) {
      final isLast = i == levels.length - 1;
      final current = levels[i];
      _currentLevel = current;

      final fromXP = (i == 0) ? widget.previous.xp : 0;
      final toXP = isLast ? widget.current.xp : current.xpRequired;

      final int animationStart = fromXP;
      final int animationEnd = toXP;

      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      );

      setState(() {
        _xpProgress = animationStart * 10;
      });
      await Future.delayed(const Duration(seconds: 1), () {});

      final animation = IntTween(
        begin: animationStart * 10,
        end: animationEnd * 10,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      animation.addListener(() {
        setState(() {
          _xpProgress = animation.value;

          if (animation.isCompleted && !isLast) {
            widget.onLevelUp();
          }
        });
      });

      await controller.forward();
      controller.dispose();

      // reset to 0 if not final
      if (!isLast) {
        setState(() => _xpProgress = 0);
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedProgressIndicator(
            progress: _xpProgress,
            fullAmount: _currentLevel.xpRequired * 10,
            textLeft: '${_currentLevel.icon} ${_currentLevel.name}',
            textRight: Text(
                '${(_xpProgress / 10).round()} / ${_currentLevel.xpRequired} XP')),
      ],
    );
  }
}
