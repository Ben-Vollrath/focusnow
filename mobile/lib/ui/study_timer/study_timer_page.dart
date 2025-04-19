import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/bloc/study_timer/study_timer_bloc.dart';
import 'package:focusnow/bloc/study_timer/timer_variant.dart';
import 'package:focusnow/ui/study_timer/circular_timer.dart';
import 'package:focusnow/ui/study_timer/progress_display/progress_display.dart';
import 'package:focusnow/ui/study_timer/timer_button.dart';

class StudyTimerPage extends StatefulWidget {
  const StudyTimerPage({super.key});

  @override
  State<StudyTimerPage> createState() => _StudyTimerPageState();
}

class _StudyTimerPageState extends State<StudyTimerPage> {
  late ConfettiController _confettiController;

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${duration.inHours > 0 ? '${duration.inHours}:' : ''}$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudyTimerBloc, StudyTimerState>(
      listenWhen: (_, state) => state.status == TimerStatus.completed,
      listener: (context, state) {
        context.read<StatsBloc>().add(ReloadUserStats());
        context.read<ChallengeBloc>().add(LoadChallenges());
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Study Timer')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<StudyTimerBloc, StudyTimerState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      ProgressDisplay(
                        onLevelUp: () {
                          _confettiController.play();
                        },
                      ),
                      Center(
                        child: ConfettiWidget(
                          confettiController: _confettiController,
                          blastDirectionality: BlastDirectionality.explosive,
                          shouldLoop: false,
                          emissionFrequency: 0.6,
                          numberOfParticles: 25,
                          maxBlastForce: 15,
                          minBlastForce: 5,
                          minimumSize: const Size(5, 5),
                          maximumSize: const Size(10, 10),
                          gravity: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
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
                    onTap: () {
                      switch (state.status) {
                        case TimerStatus.initial:
                        case TimerStatus.stopped:
                        case TimerStatus.completed:
                          context.read<StudyTimerBloc>().add(StartTimer());
                          break;
                        case TimerStatus.running:
                          context.read<StudyTimerBloc>().add(PauseTimer());
                          break;
                        case TimerStatus.paused:
                          context.read<StudyTimerBloc>().add(ResumeTimer());
                          break;
                      }
                    },
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
                    if (state.phase == TimerPhase.work)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TimerButton(
                            onPressed: () => context
                                .read<StudyTimerBloc>()
                                .add(PauseTimer()),
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
                    else if (state.phase == TimerPhase.breakTime)
                      Align(
                        alignment: Alignment.center,
                        child: TimerButton(
                          onPressed: () =>
                              context.read<StudyTimerBloc>().add(StopTimer()),
                          icon: Icons.fast_forward_sharp,
                        ),
                      )
                    else if (state.status == TimerStatus.paused)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TimerButton(
                            onPressed: () => context
                                .read<StudyTimerBloc>()
                                .add(ResumeTimer()),
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
                  Spacer(),
                ],
              );
            },
          ),
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
                      ? const Icon(Icons.check, color: Color(0xFF3FBF7F))
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
