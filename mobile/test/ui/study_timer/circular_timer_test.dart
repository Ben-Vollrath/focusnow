import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/study_timer/study_timer_bloc.dart';
import 'package:focusnow/ui/study_timer/circular_timer.dart';
import 'package:mocktail/mocktail.dart';

class MockStudyTimerBloc extends MockBloc<StudyTimerEvent, StudyTimerState>
    implements StudyTimerBloc {}

void main() {
  late MockStudyTimerBloc mockBloc;

  setUp(() {
    mockBloc = MockStudyTimerBloc();
  });

  Widget buildWidget({
    required Duration remaining,
    required Duration total,
    required String label,
    required TimerPhase phase,
  }) {
    when(() => mockBloc.state).thenReturn(
      StudyTimerState.initial().copyWith(phase: phase),
    );

    return MaterialApp(
      home: BlocProvider<StudyTimerBloc>.value(
        value: mockBloc,
        child: CircularTimer(
          remaining: remaining,
          total: total,
          label: label,
          isWorkPhase: phase == TimerPhase.work,
        ),
      ),
    );
  }

  testWidgets('displays correct formatted time', (tester) async {
    await tester.pumpWidget(buildWidget(
      remaining: const Duration(minutes: 25),
      total: const Duration(minutes: 25),
      label: 'Work',
      phase: TimerPhase.work,
    ));

    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('Work'), findsOneWidget);
  });

  testWidgets('displays 0% progress safely when total is zero', (tester) async {
    await tester.pumpWidget(buildWidget(
      remaining: const Duration(seconds: 0),
      total: const Duration(seconds: 0),
      label: 'Idle',
      phase: TimerPhase.work,
    ));

    final progress = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );

    expect(progress.value, 0.0);
  });

  testWidgets('displays correct percentage progress', (tester) async {
    await tester.pumpWidget(buildWidget(
      remaining: const Duration(minutes: 10),
      total: const Duration(minutes: 20),
      label: 'Focus',
      phase: TimerPhase.work,
    ));

    final progress = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );

    expect(progress.value, closeTo(0.5, 0.01));
  });

  testWidgets('uses primary color during work phase', (tester) async {
    await tester.pumpWidget(buildWidget(
      remaining: const Duration(minutes: 10),
      total: const Duration(minutes: 20),
      label: 'Focus',
      phase: TimerPhase.work,
    ));

    final progress = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );

    final theme = ThemeData();
    expect(
      (progress.valueColor as AlwaysStoppedAnimation).value,
      theme.colorScheme.primary,
    );
  });

  testWidgets('uses green color during break phase', (tester) async {
    await tester.pumpWidget(buildWidget(
      remaining: const Duration(minutes: 5),
      total: const Duration(minutes: 10),
      label: 'Break',
      phase: TimerPhase.breakTime,
    ));

    final progress = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );

    expect(
      (progress.valueColor as AlwaysStoppedAnimation).value,
      const Color(0xFF3FBF7F),
    );
  });
}
