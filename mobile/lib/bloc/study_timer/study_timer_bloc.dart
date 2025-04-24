import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:focusnow/bloc/study_timer/timer_variant.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:study_session_repository/study_session.dart';
import 'package:study_session_repository/study_session_repository.dart';

part 'study_timer_event.dart';
part 'study_timer_state.dart';

class StudyTimerBloc extends Bloc<StudyTimerEvent, StudyTimerState> {
  final StudySessionRepository sessionRepository;
  final NotificationRepository notificationRepository;
  Timer? _ticker;

  StudyTimerBloc(this.sessionRepository, this.notificationRepository)
      : super(StudyTimerState.initial()) {
    on<SelectTimerVariant>((event, emit) {
      emit(state.copyWith(variant: event.variant));
    });

    on<RetryUnsentSessions>((event, emit) async {
      await sessionRepository.retryUnsentSessions();
    });

    on<StartTimer>((event, emit) {
      _ticker?.cancel();
      emit(state.copyWith(
        status: TimerStatus.running,
        startTime: DateTime.now(),
        elapsed: Duration(seconds: 1),
      ));
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        add(Tick());
      });
    });

    on<Tick>((event, emit) {
      //Hack to have correct elapsed timer after pause
      if (state.status == TimerStatus.paused) {
        emit(state.copyWith(
          startTime: state.startTime!.add(Duration(seconds: 1)),
        ));
      }

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
              elapsed: Duration(seconds: 1),
            ));

            notificationRepository.showStudySessionBreakNotification();
          } else {
            emit(state.copyWith(elapsed: elapsed));
          }
        } else if (state.phase == TimerPhase.breakTime) {
          if (elapsed >= breakDuration) {
            _ticker?.cancel();
            _emitCompletedState(state, emit);
            notificationRepository.showStudySessionCompletedNotification();
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
          _emitCompletedState(state, emit);
          notificationRepository.showStudySessionCompletedNotification();
        } else {
          emit(state.copyWith(elapsed: elapsed));
        }
      }
    });

    on<PauseTimer>((event, emit) {
      emit(state.copyWith(status: TimerStatus.paused));
    });

    on<ResumeTimer>((event, emit) {
      emit(state.copyWith(status: TimerStatus.running));
    });

    on<StopTimer>((event, emit) async {
      _ticker?.cancel();

      if (state.phase == TimerPhase.breakTime) {
        _emitCompletedState(state, emit);
        return;
      }

      final sessionIsCounted =
          state.startTime != null && state.elapsed.inMinutes >= 5;

      if (sessionIsCounted) {
        await sessionRepository.submitStudySession(StudySession(
            startTime: state.startTime!,
            endTime: state.startTime!.add(state.elapsed)));

        _emitCompletedState(state, emit);
      } else {
        emit(state.copyWithNullStartTime(
          phase: TimerPhase.work,
          status: TimerStatus.stopped,
          elapsed: Duration.zero,
        ));
      }
    });
  }

  Future<void> _emitCompletedState(
    StudyTimerState state,
    Emitter<StudyTimerState> emit,
  ) async {
    emit(state.copyWithNullStartTime(
      status: TimerStatus.completed,
      elapsed: Duration.zero,
      phase: TimerPhase.work,
    ));
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
