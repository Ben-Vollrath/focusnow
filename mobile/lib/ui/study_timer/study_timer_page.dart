import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/study_timer/study_timer_bloc.dart';
import 'package:focusnow/ui/study_timer/progress_display/study_timer_view.dart';
import 'package:focusnow/ui/widgets/profile_dropdown.dart';

class StudyTimerPage extends StatefulWidget {
  const StudyTimerPage({super.key});

  @override
  State<StudyTimerPage> createState() => _StudyTimerPageState();
}

class _StudyTimerPageState extends State<StudyTimerPage> {
  @override
  void initState() {
    super.initState();
    AnalyticsRepository().logScreen("study_timer_page");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudyTimerBloc, StudyTimerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title: AnimatedSlide(
            offset: state.canInteractOutsideTimer
                ? Offset.zero
                : const Offset(0, -1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Study Timer'),
                const ProfileDropdownButton(),
              ],
            ),
          )),
          body: StudyTimerView(),
        );
      },
    );
  }
}
