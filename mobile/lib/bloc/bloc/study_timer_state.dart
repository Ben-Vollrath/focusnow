part of 'study_timer_bloc.dart';

enum TimerStatus { initial, running, paused, stopped, completed }

enum TimerPhase { work, breakTime }

class StudyTimerState {
  final TimerStatus status;
  final Duration elapsed;
  final DateTime? startTime;
  final TimerVariant variant;
  final TimerPhase phase;

  const StudyTimerState({
    required this.status,
    required this.elapsed,
    required this.variant,
    required this.phase,
    this.startTime,
  });

  bool get canChangeVariant =>
      status != TimerStatus.running && status != TimerStatus.paused;

  Duration get totalDuration {
    if (variant.hasPause) {
      return phase == TimerPhase.work
          ? variant.getWorkDuration()
          : variant.getBreakDuration();
    } else {
      return variant.getWorkDuration();
    }
  }

  Duration get remaining => totalDuration - elapsed;

  factory StudyTimerState.initial() {
    return const StudyTimerState(
      status: TimerStatus.initial,
      elapsed: Duration.zero,
      variant: TimerVariant.pomodoro,
      phase: TimerPhase.work,
    );
  }

  StudyTimerState copyWith({
    TimerStatus? status,
    Duration? elapsed,
    DateTime? startTime,
    TimerVariant? variant,
    TimerPhase? phase,
  }) {
    return StudyTimerState(
      status: status ?? this.status,
      elapsed: elapsed ?? this.elapsed,
      startTime: startTime ?? this.startTime,
      variant: variant ?? this.variant,
      phase: phase ?? this.phase,
    );
  }
}
