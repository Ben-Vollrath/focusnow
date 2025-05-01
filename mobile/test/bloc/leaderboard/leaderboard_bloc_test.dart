import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_entry.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:focusnow/bloc/leaderboard/leaderboard_bloc.dart';

class MockLeaderboardRepository extends Mock implements LeaderboardRepository {}

void main() {
  late MockLeaderboardRepository mockRepository;

  const testUserId = 'test-user-id';
  final mockDaily = [
    LeaderboardEntry(
      userId: testUserId,
      name: 'Test User',
      totalStudyTime: 120,
      totalStudySessions: 5,
      rank: 1,
    ),
  ];

  final mockTotal = [
    LeaderboardEntry(
      userId: testUserId,
      name: 'Test User',
      totalStudyTime: 600,
      totalStudySessions: 25,
      rank: 3,
    ),
  ];

  setUp(() {
    mockRepository = MockLeaderboardRepository();
  });

  group('LeaderboardBloc', () {
    blocTest<LeaderboardBloc, LeaderboardState>(
      'emits [loading, loaded] when leaderboard is loaded successfully',
      build: () {
        when(() => mockRepository.fetchDailyLeaderboard(testUserId))
            .thenAnswer((_) async => mockDaily);
        when(() => mockRepository.fetchTotalLeaderboard(testUserId))
            .thenAnswer((_) async => mockTotal);
        return LeaderboardBloc(leaderboardRepository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadLeaderboard(userId: testUserId)),
      expect: () => [
        LeaderboardState.initial().copyWith(status: LeaderBoardStatus.loading),
        LeaderboardState.initial().copyWith(
          dailyLeaderboard: mockDaily,
          totalLeaderboard: mockTotal,
          status: LeaderBoardStatus.loaded,
        ),
      ],
    );

    blocTest<LeaderboardBloc, LeaderboardState>(
      'emits [loading, error] when repository throws',
      build: () {
        when(() => mockRepository.fetchDailyLeaderboard(testUserId))
            .thenThrow(Exception('fail'));
        when(() => mockRepository.fetchTotalLeaderboard(testUserId))
            .thenThrow(Exception('fail'));
        return LeaderboardBloc(leaderboardRepository: mockRepository);
      },
      act: (bloc) => bloc.add(LoadLeaderboard(userId: testUserId)),
      expect: () => [
        LeaderboardState.initial().copyWith(status: LeaderBoardStatus.loading),
        LeaderboardState.initial().copyWith(status: LeaderBoardStatus.error),
      ],
    );

    blocTest<LeaderboardBloc, LeaderboardState>(
      'changes leaderboard type when LeaderboardTypeChanged is added',
      build: () => LeaderboardBloc(leaderboardRepository: mockRepository),
      act: (bloc) => bloc.add(LeaderboardTypeChanged(LeaderboardType.total)),
      expect: () => [
        LeaderboardState.initial()
            .copyWith(selectedType: LeaderboardType.total),
      ],
    );
  });
}
