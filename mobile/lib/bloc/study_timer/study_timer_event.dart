part of 'study_timer_bloc.dart';

abstract class StudyTimerEvent {}

class SelectTimerVariant extends StudyTimerEvent {
  final TimerVariant variant;
  SelectTimerVariant(this.variant);
}

class StartTimer extends StudyTimerEvent {}

class PauseTimer extends StudyTimerEvent {}

class ResumeTimer extends StudyTimerEvent {}

class StopTimer extends StudyTimerEvent {}

class Tick extends StudyTimerEvent {}

class RetryUnsentSessions extends StudyTimerEvent {}
