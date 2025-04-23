// ignore_for_file: prefer_const_constructors
import 'package:focusnow/bloc/goal/goal_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_repository/goal.dart';

void main() {
  group('GoalState', () {
    test('copywith works correclty', () {
      final goal = Goal(
          id: "id",
          createdAt: DateTime(2024, 1, 1),
          targetDate: DateTime(2024, 1, 1),
          targetMinutes: 10,
          currentMinutes: 100,
          completed: false,
          name: "name",
          xpReward: 10);

      final sourceState = GoalState.initial();
      final newState = sourceState.copyWith(
          status: GoalStatus.loaded, goal: goal, error: "test");

      expect(newState.goal, goal);
      expect(newState.status, GoalStatus.loaded);
      expect(newState.error, "test");
    });
  });
}
