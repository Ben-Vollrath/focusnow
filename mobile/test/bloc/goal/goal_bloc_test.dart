import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_repository/goal.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:focusnow/bloc/goal/goal_bloc.dart';

class MockGoalRepository extends Mock implements GoalRepository {}

void main() {
  late MockGoalRepository mockGoalRepository;

  final testGoal = Goal(
    id: 'goal_1',
    createdAt: DateTime(2024, 1, 1),
    targetDate: DateTime(2024, 2, 1),
    targetMinutes: 600,
    currentMinutes: 120,
    completed: false,
    name: 'Study More',
    xpReward: 300,
  );

  final inputGoal = InputGoal(
    name: 'Study More',
    targetMinutes: 600,
    targetDate: DateTime(2024, 2, 1),
  );

  setUp(() {
    mockGoalRepository = MockGoalRepository();
  });

  group('GoalBloc', () {
    blocTest<GoalBloc, GoalState>(
      'emits [loading, loaded] when LoadGoal succeeds',
      build: () {
        when(() => mockGoalRepository.getGoal())
            .thenAnswer((_) async => testGoal);
        return GoalBloc(goalRepository: mockGoalRepository);
      },
      act: (bloc) => bloc.add(LoadGoal()),
      expect: () => [
        GoalState.initial().copyWith(status: GoalStatus.loading),
        GoalState.initial().copyWith(status: GoalStatus.loaded, goal: testGoal),
      ],
      verify: (_) {
        verify(() => mockGoalRepository.getGoal()).called(1);
      },
    );

    blocTest<GoalBloc, GoalState>(
      'emits [loading, error] when LoadGoal fails',
      build: () {
        when(() => mockGoalRepository.getGoal()).thenThrow(Exception('error'));
        return GoalBloc(goalRepository: mockGoalRepository);
      },
      act: (bloc) => bloc.add(LoadGoal()),
      expect: () => [
        GoalState.initial().copyWith(status: GoalStatus.loading),
        GoalState.initial().copyWith(
          status: GoalStatus.error,
          error: "Exception: error",
        ),
      ],
    );

    blocTest<GoalBloc, GoalState>(
      'emits [loading] then triggers LoadGoal on CreateGoal',
      build: () {
        when(() => mockGoalRepository.createGoal(inputGoal))
            .thenAnswer((_) async {});
        when(() => mockGoalRepository.getGoal())
            .thenAnswer((_) async => testGoal);
        return GoalBloc(goalRepository: mockGoalRepository);
      },
      act: (bloc) => bloc.add(CreateGoal(inputGoal)),
      wait: const Duration(milliseconds: 10),
      expect: () => [
        GoalState.initial().copyWith(status: GoalStatus.loading),
        GoalState.initial().copyWith(status: GoalStatus.loaded, goal: testGoal),
      ],
      verify: (_) {
        verify(() => mockGoalRepository.createGoal(inputGoal)).called(1);
        verify(() => mockGoalRepository.getGoal()).called(1);
      },
    );

    blocTest<GoalBloc, GoalState>(
      'emits [loading, loaded (null)] on DeleteGoal',
      build: () {
        when(() => mockGoalRepository.deleteGoal('goal_1'))
            .thenAnswer((_) async {});
        return GoalBloc(goalRepository: mockGoalRepository);
      },
      act: (bloc) => bloc.add(DeleteGoal('goal_1')),
      expect: () => [
        GoalState.initial().copyWith(status: GoalStatus.loading),
        GoalState(status: GoalStatus.loaded, goal: null),
      ],
      verify: (_) {
        verify(() => mockGoalRepository.deleteGoal('goal_1')).called(1);
      },
    );

    blocTest<GoalBloc, GoalState>(
      'emits [loading, error] when DeleteGoal fails',
      build: () {
        when(() => mockGoalRepository.deleteGoal('goal_1'))
            .thenThrow(Exception('delete failed'));
        return GoalBloc(goalRepository: mockGoalRepository);
      },
      act: (bloc) => bloc.add(DeleteGoal('goal_1')),
      expect: () => [
        GoalState.initial().copyWith(status: GoalStatus.loading),
        GoalState.initial().copyWith(
          status: GoalStatus.error,
          error: "Exception: delete failed",
        ),
      ],
    );
  });
}
