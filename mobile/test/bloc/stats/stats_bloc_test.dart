import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stats_repository/daily_study_data.dart';
import 'package:stats_repository/level.dart';
import 'package:stats_repository/stats_repository.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:stats_repository/user_stats.dart';

class MockStatsRepository extends Mock implements StatsRepository {}

void main() {
  late MockStatsRepository mockStatsRepository;

  final userStats = UserStats(
    level: 5,
    xp: 1200,
    xpToNext: 300,
    levelName: 'Focused Fox',
    levelIcon: 'fox',
    totalStudyTime: 720,
    totalStudySessions: 40,
  );

  final weeklyStudyData = [
    DailyStudyData(
      studyDate: '2025-04-20',
      totalStudyTime: 60,
      totalStudySessions: 2,
      streakDay: 1,
    ),
    DailyStudyData(
      studyDate: '2025-04-21',
      totalStudyTime: 90,
      totalStudySessions: 3,
      streakDay: 2,
    ),
  ];

  final levels = [
    Level(level: 1, name: 'Beginner', icon: 'leaf', xpRequired: 0),
    Level(level: 2, name: 'Intermediate', icon: 'fire', xpRequired: 500),
  ];

  setUp(() {
    mockStatsRepository = MockStatsRepository();
  });

  group('StatsBloc', () {
    blocTest<StatsBloc, StatsState>(
      'emits [loading, success] with stats on LoadStats',
      build: () {
        when(() => mockStatsRepository.getUserStats())
            .thenAnswer((_) async => userStats);
        when(() => mockStatsRepository.getWeeklyStudyData())
            .thenAnswer((_) async => weeklyStudyData);
        when(() => mockStatsRepository.getLevels())
            .thenAnswer((_) async => levels);

        return StatsBloc(statsRepository: mockStatsRepository);
      },
      act: (bloc) => bloc.add(LoadStats()),
      expect: () => [
        StatsState().copyWith(status: StatsStatus.loading),
        StatsState().copyWith(
          status: StatsStatus.success,
          userStats: userStats,
          weeklyStudyData: weeklyStudyData,
          levels: levels,
        ),
      ],
      verify: (_) {
        verify(() => mockStatsRepository.getUserStats()).called(1);
        verify(() => mockStatsRepository.getWeeklyStudyData()).called(1);
        verify(() => mockStatsRepository.getLevels()).called(1);
      },
    );

    blocTest<StatsBloc, StatsState>(
      'emits [loading, failure] on LoadStats error',
      build: () {
        when(() => mockStatsRepository.getUserStats())
            .thenThrow(Exception('Failed'));
        return StatsBloc(statsRepository: mockStatsRepository);
      },
      act: (bloc) => bloc.add(LoadStats()),
      expect: () => [
        StatsState().copyWith(status: StatsStatus.loading),
        StatsState().copyWith(
          status: StatsStatus.failure,
          errorMessage: 'Exception: Failed',
        ),
      ],
    );

    blocTest<StatsBloc, StatsState>(
      'emits [loading, success] on ReloadUserStats (no levels)',
      build: () {
        when(() => mockStatsRepository.getUserStats())
            .thenAnswer((_) async => userStats);
        when(() => mockStatsRepository.getWeeklyStudyData())
            .thenAnswer((_) async => weeklyStudyData);

        return StatsBloc(statsRepository: mockStatsRepository);
      },
      act: (bloc) => bloc.add(ReloadUserStats()),
      expect: () => [
        StatsState().copyWith(status: StatsStatus.loading),
        StatsState().copyWith(
          status: StatsStatus.success,
          userStats: userStats,
          weeklyStudyData: weeklyStudyData,
        ),
      ],
      verify: (_) {
        verify(() => mockStatsRepository.getUserStats()).called(1);
        verify(() => mockStatsRepository.getWeeklyStudyData()).called(1);
        verifyNever(() => mockStatsRepository.getLevels());
      },
    );

    blocTest<StatsBloc, StatsState>(
      'emits [loading, failure] on ReloadUserStats error',
      build: () {
        when(() => mockStatsRepository.getUserStats())
            .thenThrow(Exception('Reload error'));

        return StatsBloc(statsRepository: mockStatsRepository);
      },
      act: (bloc) => bloc.add(ReloadUserStats()),
      expect: () => [
        StatsState().copyWith(status: StatsStatus.loading),
        StatsState().copyWith(
          status: StatsStatus.failure,
          errorMessage: 'Exception: Reload error',
        ),
      ],
    );
  });
}
