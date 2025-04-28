import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/study_timer/study_timer_bloc.dart';
import 'package:focusnow/bloc/study_timer/timer_variant.dart';
import 'package:focusnow/ui/study_timer/progress_display/study_timer_view.dart';

class OnboardingDemo extends StatefulWidget {
  const OnboardingDemo({super.key});

  @override
  State<OnboardingDemo> createState() => _OnboardingDemoState();
}

class _OnboardingDemoState extends State<OnboardingDemo> {
  @override
  void initState() {
    super.initState();

    context
        .read<StudyTimerBloc>()
        .add(SelectTimerVariant(TimerVariant.motivation));
  }

  @override
  Widget build(BuildContext context) {
    return StudyTimerView(allowChangeVariant: false);
  }
}
