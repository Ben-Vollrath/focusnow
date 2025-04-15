import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/bloc/study_timer_bloc.dart';
import 'package:focusnow/bloc/bloc/timer_variant.dart';
import 'package:focusnow/ui/study_timer/circular_timer.dart';
import 'package:focusnow/ui/study_timer/timer_button.dart';

class StudyTimerPage extends StatelessWidget {
  const StudyTimerPage({super.key});

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${duration.inHours > 0 ? '${duration.inHours}:' : ''}$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Timer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<StudyTimerBloc, StudyTimerState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Timer Display
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      if (state.canChangeVariant) {
                        _showVariantSelector(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: state.canChangeVariant
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(124)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.variant.icon,
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            state.variant.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 4),
                          state.canChangeVariant
                              ? const Icon(Icons.arrow_drop_down)
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                GestureDetector(
                  onTap: () => context.read<StudyTimerBloc>().add(StartTimer()),
                  child: CircularTimer(
                    remaining: state.variant == TimerVariant.endless
                        ? state.elapsed
                        : state.remaining,
                    total: state.totalDuration,
                    label: state.phase == TimerPhase.work
                        ? 'Work Phase'
                        : 'Break Time',
                    isWorkPhase: state.phase == TimerPhase.work,
                  ),
                ),

                const SizedBox(height: 48),
                // Action Buttons
                if (state.status == TimerStatus.initial ||
                    state.status == TimerStatus.stopped ||
                    state.status == TimerStatus.completed)
                  Align(
                    alignment: Alignment.center,
                    child: TimerButton(
                      onPressed: () =>
                          context.read<StudyTimerBloc>().add(StartTimer()),
                      icon: Icons.play_arrow,
                    ),
                  )
                else if (state.status == TimerStatus.running)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TimerButton(
                        onPressed: () =>
                            context.read<StudyTimerBloc>().add(PauseTimer()),
                        icon: Icons.pause,
                      ),
                      const SizedBox(width: 24),
                      TimerButton(
                        onPressed: () =>
                            context.read<StudyTimerBloc>().add(StopTimer()),
                        icon: Icons.stop,
                      )
                    ],
                  )
                else if (state.status == TimerStatus.paused)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TimerButton(
                        onPressed: () =>
                            context.read<StudyTimerBloc>().add(ResumeTimer()),
                        icon: Icons.play_arrow,
                      ),
                      const SizedBox(width: 24),
                      TimerButton(
                        onPressed: () =>
                            context.read<StudyTimerBloc>().add(StopTimer()),
                        icon: Icons.stop,
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showVariantSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: false,
      builder: (_) {
        final current = context.read<StudyTimerBloc>().state.variant;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final variant in TimerVariant.values) ...[
                ListTile(
                  leading:
                      Text(variant.icon, style: const TextStyle(fontSize: 20)),
                  title: Text(
                    variant.name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(variant.description),
                  trailing: variant == current
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    context
                        .read<StudyTimerBloc>()
                        .add(SelectTimerVariant(variant));
                    Navigator.of(context).pop();
                  },
                ),
                if (variant != TimerVariant.values.last)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(),
                  ),
              ]
            ],
          ),
        );
      },
    );
  }
}
