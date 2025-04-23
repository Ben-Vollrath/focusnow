import 'package:bloc_test/bloc_test.dart';
import 'package:challenge_repository/challenge.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';

class MockChallengeRepository extends Mock implements ChallengeRepository {}

void main() {
  late MockChallengeRepository mockChallengeRepository;

  setUp(() {
    mockChallengeRepository = MockChallengeRepository();
  });

  group('ChallengeBloc', () {
    final testChallenges = [
      ChallengeWithProgress(
        challenge: Challenge(
          id: '1',
          name: 'Study 1 Hour',
          description: 'Study at least 1 hour total',
          icon: 'hourglass',
          category: ChallengeCategory.total_hours,
          reward_xp: 100,
          is_repeatable: false,
          condition_amount: 1,
          difficulty: 1,
        ),
        progress: null,
      ),
      ChallengeWithProgress(
        challenge: Challenge(
          id: '2',
          name: 'Study Every Day',
          description: 'Complete a session every day',
          icon: 'calendar',
          category: ChallengeCategory.daily_sessions,
          reward_xp: 150,
          is_repeatable: true,
          condition_amount: 5,
          difficulty: 2,
        ),
        progress: null,
      ),
    ];

    blocTest<ChallengeBloc, ChallengeState>(
      'emits [loading, loaded] with challenges from repository',
      build: () {
        when(() => mockChallengeRepository.getChallengesWithProgress())
            .thenAnswer((_) async => testChallenges);
        return ChallengeBloc(repository: mockChallengeRepository);
      },
      act: (bloc) => bloc.add(LoadChallenges()),
      expect: () => [
        ChallengeState.initial().copyWith(status: Status.loading),
        ChallengeState.initial().copyWith(
          status: Status.loaded,
          challenges: testChallenges,
        ),
      ],
      verify: (_) {
        verify(() => mockChallengeRepository.getChallengesWithProgress())
            .called(1);
      },
    );

    blocTest<ChallengeBloc, ChallengeState>(
      'emits [loading, error] when repository throws',
      build: () {
        when(() => mockChallengeRepository.getChallengesWithProgress())
            .thenThrow(Exception('failed to fetch'));
        return ChallengeBloc(repository: mockChallengeRepository);
      },
      act: (bloc) => bloc.add(LoadChallenges()),
      expect: () => [
        ChallengeState.initial().copyWith(status: Status.loading),
        ChallengeState.initial().copyWith(status: Status.error),
      ],
    );

    blocTest<ChallengeBloc, ChallengeState>(
      'filters challenges by category',
      build: () {
        when(() => mockChallengeRepository.getChallengesWithProgress())
            .thenAnswer((_) async => testChallenges);
        return ChallengeBloc(repository: mockChallengeRepository);
      },
      act: (bloc) async {
        bloc.add(LoadChallenges());
        await Future.delayed(Duration.zero); // allow previous event to finish
        bloc.add(FilterByCategory(ChallengeCategory.daily_sessions));
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        ChallengeState.initial().copyWith(status: Status.loading),
        ChallengeState.initial().copyWith(
          status: Status.loaded,
          challenges: testChallenges,
        ),
        ChallengeState(
          challenges: testChallenges,
          status: Status.loaded,
          selectedCategory: ChallengeCategory.daily_sessions,
        ),
        ChallengeState(
          challenges: [testChallenges[1]],
          status: Status.loaded,
          selectedCategory: ChallengeCategory.daily_sessions,
        ),
      ],
    );
  });
}
