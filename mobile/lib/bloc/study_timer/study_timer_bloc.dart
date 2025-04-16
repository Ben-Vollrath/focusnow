import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:focusnow/bloc/study_timer/timer_variant.dart';
import 'package:meta/meta.dart';
import 'package:study_session_repository/study_session.dart';
import 'package:study_session_repository/study_session_repository.dart';

part 'study_timer_event.dart';
part 'study_timer_state.dart';

class StudyTimerBloc extends Bloc<StudyTimerEvent, StudyTimerState> {
  final StudySessionRepository sessionRepository;
  Timer? _ticker;

  StudyTimerBloc(this.sessionRepository) : super(StudyTimerState.initial()) {
    on<SelectTimerVariant>((event, emit) {
      emit(state.copyWith(variant: event.variant));
    });

    on<StartTimer>((event, emit) {
      _ticker?.cancel();
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        add(Tick());
      });
      emit(state.copyWith(
        status: TimerStatus.running,
        startTime: DateTime.now(),
      ));
    });

    on<Tick>((event, emit) {
      final now = DateTime.now();
      final elapsed = now.difference(state.startTime!);

      final workDuration = state.variant.getWorkDuration();
      final breakDuration = state.variant.getBreakDuration();

      if (state.variant.hasPause) {
        if (state.phase == TimerPhase.work) {
          if (elapsed >= workDuration) {
            _ticker?.cancel();
            sessionRepository.submitStudySession(StudySession(
              startTime: state.startTime!,
              endTime: state.startTime!.add(workDuration),
            ));
            // Start break
            _ticker =
                Timer.periodic(const Duration(seconds: 1), (_) => add(Tick()));
            emit(state.copyWith(
              phase: TimerPhase.breakTime,
              status: TimerStatus.running,
              startTime: DateTime.now(),
              elapsed: workDuration, // don't increase during break
            ));
          } else {
            emit(state.copyWith(elapsed: elapsed));
          }
        } else if (state.phase == TimerPhase.breakTime) {
          if (elapsed >= breakDuration) {
            _ticker?.cancel();
            emit(StudyTimerState.initial()
                .copyWith(status: TimerStatus.completed));
          } else {
            emit(state.copyWith(
              elapsed: elapsed,
            ));
          }
        }
      } else {
        if (elapsed >= workDuration) {
          _ticker?.cancel();
          sessionRepository.submitStudySession(StudySession(
            startTime: state.startTime!,
            endTime: state.startTime!.add(workDuration),
          ));
          emit(state.copyWith(
              status: TimerStatus.completed,
              elapsed: workDuration,
              phase: TimerPhase.work));
        } else {
          emit(state.copyWith(elapsed: elapsed));
        }
      }
    });

    on<PauseTimer>((event, emit) {
      _ticker?.cancel();
      emit(state.copyWith(status: TimerStatus.paused));
    });

    on<ResumeTimer>((event, emit) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) => add(Tick()));
      emit(state.copyWith(status: TimerStatus.running));
    });

    on<StopTimer>((event, emit) {
      _ticker?.cancel();
      if (state.startTime != null && state.elapsed.inMinutes > 5) {
        sessionRepository.submitStudySession(StudySession(
            startTime: state.startTime!,
            endTime: state.startTime!.add(state.elapsed)));
      }
      emit(state.copyWith(
        phase: TimerPhase.work,
        status: TimerStatus.stopped,
        elapsed: Duration.zero,
        startTime: null,
      ));
    });
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
