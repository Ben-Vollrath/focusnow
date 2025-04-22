import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/bloc/study_timer/timer_variant.dart';
import 'package:mocktail/mocktail.dart';
import 'package:focusnow/bloc/study_timer/study_timer_bloc.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:study_session_repository/study_session.dart';
import 'package:study_session_repository/study_session_repository.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

class MockStudySessionRepository extends Mock
    implements StudySessionRepository {}

class FakeStudySession extends Fake implements StudySession {}

void main() {
  late MockNotificationRepository mockNotificationRepository;
  late MockStudySessionRepository mockSessionRepository;

  setUpAll(() {
    mockNotificationRepository = MockNotificationRepository();
    mockSessionRepository = MockStudySessionRepository();

    registerFallbackValue(FakeStudySession());

    when(() => mockSessionRepository.submitStudySession(any()))
        .thenAnswer((_) async {});
  });

  group('StudyTimerBloc', () {
    blocTest<StudyTimerBloc, StudyTimerState>(
      'emits updated variant on SelectTimerVariant',
      build: () =>
          StudyTimerBloc(mockSessionRepository, mockNotificationRepository),
      act: (bloc) => bloc.add(SelectTimerVariant(TimerVariant.ninetyThirty)),
      expect: () => [
        StudyTimerState.initial().copyWith(variant: TimerVariant.ninetyThirty),
      ],
    );

    blocTest<StudyTimerBloc, StudyTimerState>(
      'starts timer and emits running state',
      build: () =>
          StudyTimerBloc(mockSessionRepository, mockNotificationRepository),
      act: (bloc) => bloc.add(StartTimer()),
      verify: (bloc) {
        expect(bloc.state.status, TimerStatus.running);
        expect(bloc.state.startTime, isNotNull);
      },
    );

    blocTest<StudyTimerBloc, StudyTimerState>(
      'ticks and updates elapsed time during work phase',
      build: () =>
          StudyTimerBloc(mockSessionRepository, mockNotificationRepository),
      seed: () => StudyTimerState.initial().copyWith(
        status: TimerStatus.running,
        startTime: DateTime.now().subtract(const Duration(seconds: 3)),
      ),
      act: (bloc) => bloc.add(Tick()),
      expect: () => [
        isA<StudyTimerState>().having((s) => s.elapsed.inSeconds,
            'elapsed.inSeconds', greaterThanOrEqualTo(3)),
      ],
    );

    blocTest<StudyTimerBloc, StudyTimerState>(
      'stops short session (<5min) without saving',
      build: () =>
          StudyTimerBloc(mockSessionRepository, mockNotificationRepository),
      seed: () => StudyTimerState.initial().copyWith(
        status: TimerStatus.running,
        phase: TimerPhase.work,
        startTime: DateTime.now().subtract(const Duration(minutes: 2)),
        elapsed: const Duration(minutes: 2),
      ),
      act: (bloc) => bloc.add(StopTimer()),
      expect: () => [
        StudyTimerState.initial().copyWith(
          phase: TimerPhase.work,
          status: TimerStatus.stopped,
          elapsed: Duration.zero,
          startTime: null,
        ),
      ],
      verify: (_) {
        verifyNever(() => mockSessionRepository.submitStudySession(any()));
      },
    );

    blocTest<StudyTimerBloc, StudyTimerState>(
      'stops long session (>=5min) and submits it',
      build: () =>
          StudyTimerBloc(mockSessionRepository, mockNotificationRepository),
      seed: () => StudyTimerState.initial().copyWith(
        status: TimerStatus.running,
        startTime: DateTime.now().subtract(const Duration(minutes: 5)),
        elapsed: const Duration(minutes: 5),
      ),
      act: (bloc) => bloc.add(StopTimer()),
      expect: () => [
        isA<StudyTimerState>()
            .having((s) => s.status, 'status', TimerStatus.completed),
      ],
      verify: (_) {
        verify(() => mockSessionRepository.submitStudySession(any())).called(1);
      },
    );

    blocTest<StudyTimerBloc, StudyTimerState>(
      'pauses and resumes the timer',
      build: () =>
          StudyTimerBloc(mockSessionRepository, mockNotificationRepository),
      seed: () => StudyTimerState.initial().copyWith(
        status: TimerStatus.running,
        startTime: DateTime.now(),
      ),
      act: (bloc) async {
        bloc.add(PauseTimer());
        await Future.delayed(Duration.zero);
        bloc.add(ResumeTimer());
      },
      expect: () => [
        isA<StudyTimerState>()
            .having((s) => s.status, 'status', TimerStatus.paused),
        isA<StudyTimerState>()
            .having((s) => s.status, 'status', TimerStatus.running),
      ],
    );

    group('StudyTimerBloc Tick behavior', () {
      blocTest<StudyTimerBloc, StudyTimerState>(
        'Variant with pause: transitions from work → break → complete',
        build: () {
          when(() => mockSessionRepository.submitStudySession(any()))
              .thenAnswer((_) async {});
          when(() => mockNotificationRepository
              .showStudySessionBreakNotification()).thenAnswer((_) async {});
          when(() => mockNotificationRepository
                  .showStudySessionCompletedNotification())
              .thenAnswer((_) async {});

          return StudyTimerBloc(
              mockSessionRepository, mockNotificationRepository);
        },
        seed: () {
          final now = DateTime.now();
          return StudyTimerState.initial().copyWith(
            status: TimerStatus.running,
            variant: TimerVariant.pomodoro,
            phase: TimerPhase.work,
            startTime: now.subtract(TimerVariant.pomodoro.getWorkDuration()),
          );
        },
        act: (bloc) => bloc.add(Tick()),
        expect: () => [
          isA<StudyTimerState>()
              .having((s) => s.phase, 'phase', TimerPhase.breakTime)
              .having((s) => s.status, 'status', TimerStatus.running),
        ],
        verify: (_) {
          verify(() => mockSessionRepository.submitStudySession(any()))
              .called(1);
          verify(() => mockNotificationRepository
              .showStudySessionBreakNotification()).called(1);
        },
      );

      blocTest<StudyTimerBloc, StudyTimerState>(
        'Variant with pause: completes after break ends',
        build: () {
          when(() => mockNotificationRepository
                  .showStudySessionCompletedNotification())
              .thenAnswer((_) async {});

          return StudyTimerBloc(
              mockSessionRepository, mockNotificationRepository);
        },
        seed: () {
          final now = DateTime.now();
          return StudyTimerState.initial().copyWith(
            status: TimerStatus.running,
            variant: TimerVariant.pomodoro,
            phase: TimerPhase.breakTime,
            startTime: now.subtract(TimerVariant.pomodoro.getBreakDuration()),
          );
        },
        act: (bloc) => bloc.add(Tick()),
        expect: () => [
          isA<StudyTimerState>()
              .having((s) => s.status, 'status', TimerStatus.completed)
              .having((s) => s.phase, 'phase', TimerPhase.work),
        ],
        verify: (_) {
          verify(() => mockNotificationRepository
              .showStudySessionCompletedNotification()).called(1);
        },
      );

      blocTest<StudyTimerBloc, StudyTimerState>(
        'Variant without pause: completes directly after workDuration',
        build: () {
          when(() => mockSessionRepository.submitStudySession(any()))
              .thenAnswer((_) async {});
          when(() => mockNotificationRepository
                  .showStudySessionCompletedNotification())
              .thenAnswer((_) async {});
          return StudyTimerBloc(
              mockSessionRepository, mockNotificationRepository);
        },
        seed: () {
          final now = DateTime.now();
          return StudyTimerState.initial().copyWith(
            status: TimerStatus.running,
            variant: TimerVariant.endless, // no pause
            phase: TimerPhase.work,
            startTime: now.subtract(TimerVariant.endless.getWorkDuration()),
          );
        },
        act: (bloc) => bloc.add(Tick()),
        expect: () => [
          isA<StudyTimerState>()
              .having((s) => s.status, 'status', TimerStatus.completed)
              .having((s) => s.phase, 'phase', TimerPhase.work)
              .having((s) => s.elapsed, 'elapsed', Duration.zero),
        ],
        verify: (_) {
          verify(() => mockSessionRepository.submitStudySession(any()))
              .called(1);
          verify(() => mockNotificationRepository
              .showStudySessionCompletedNotification()).called(1);
        },
      );
    });
  });
}
