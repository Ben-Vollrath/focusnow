// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/bloc/study_timer/study_timer_bloc.dart';
import 'package:focusnow/bloc/study_timer/timer_variant.dart';

void main() {
  group('StudyTimer State', () {
    test('copywith works correctly', () {
      final sourceState = StudyTimerState.initial();
      final newState = sourceState.copyWith(
        status: TimerStatus.completed,
        elapsed: Duration(minutes: 10),
        startTime: DateTime(2024, 1, 1),
        variant: TimerVariant.fiftyTwoSeventeen,
        phase: TimerPhase.breakTime,
      );

      expect(newState.status, TimerStatus.completed);
      expect(newState.elapsed, Duration(minutes: 10));
      expect(newState.startTime, DateTime(2024, 1, 1));
      expect(newState.variant, TimerVariant.fiftyTwoSeventeen);
      expect(newState.phase, TimerPhase.breakTime);
    });

    test('initial state is correct', () {
      final initialState = StudyTimerState.initial();
      expect(initialState.status, TimerStatus.initial);
      expect(initialState.elapsed, Duration.zero);
      expect(initialState.variant, TimerVariant.pomodoro);
      expect(initialState.phase, TimerPhase.work);
    });

    group('totalDuration', () {
      test('totalDuration works correctly in work mode on hasPause variants',
          () {
        final state = StudyTimerState(
          status: TimerStatus.initial,
          elapsed: Duration.zero,
          variant: TimerVariant.fiftyTwoSeventeen,
          phase: TimerPhase.work,
        );
        expect(state.totalDuration, Duration(minutes: 52));
      });
      test('totalDuration works correctly in pause mode on hasPause variants',
          () {
        final state = StudyTimerState(
          status: TimerStatus.initial,
          elapsed: Duration.zero,
          variant: TimerVariant.fiftyTwoSeventeen,
          phase: TimerPhase.breakTime,
        );
        expect(state.totalDuration, Duration(minutes: 17));
      });

      test('totalDuration works correctly on non hasPause variants', () {
        final state = StudyTimerState(
          status: TimerStatus.initial,
          elapsed: Duration.zero,
          variant: TimerVariant.endless,
          phase: TimerPhase.work,
        );
        expect(state.totalDuration, Duration(hours: 4));
      });
    });

    test('remaining works correctly', () {
      final state = StudyTimerState(
        status: TimerStatus.initial,
        elapsed: Duration(minutes: 10),
        variant: TimerVariant.fiftyTwoSeventeen,
        phase: TimerPhase.work,
      );
      expect(state.remaining, Duration(minutes: 42));
    });

    test('canInteractOutsideTimer works correctly', () {
      final state = StudyTimerState.initial();

      expect(state.canInteractOutsideTimer, true);

      final state2 = state.copyWith(status: TimerStatus.running);

      expect(state2.canInteractOutsideTimer, false);
    });
  });
}
