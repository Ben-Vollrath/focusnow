import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/study_timer/study_timer_bloc.dart';

class CircularTimer extends StatelessWidget {
  final Duration remaining;
  final Duration total;
  final String label;
  final bool isWorkPhase;

  const CircularTimer({
    super.key,
    required this.remaining,
    required this.total,
    required this.label,
    required this.isWorkPhase,
  });

  String format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${d.inHours > 0 ? '${d.inHours}:' : ''}$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final percent =
        total.inSeconds == 0 ? 0.0 : remaining.inSeconds / total.inSeconds;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: BlocBuilder<StudyTimerBloc, StudyTimerState>(
            builder: (context, state) {
              return CircularProgressIndicator(
                value: percent,
                strokeWidth: 12,
                strokeCap: StrokeCap.round,
                backgroundColor:
                    Theme.of(context).colorScheme.shadow.withAlpha(127),
                valueColor: AlwaysStoppedAnimation<Color>(
                  state.phase == TimerPhase.work
                      ? Theme.of(context).colorScheme.primary
                      : Color(0xFF3FBF7F),
                ),
              );
            },
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              format(remaining),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
