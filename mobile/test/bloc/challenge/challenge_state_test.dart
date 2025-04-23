// ignore_for_file: prefer_const_constructors
import 'package:challenge_repository/challenge.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChallengeState', () {
    test('[initial()] state sets correct fields', () {
      final state = ChallengeState.initial();
      expect(state.status, Status.initial);
      expect(state.challenges, []);
      expect(state.selectedCategory, null);
    });

    test('copywith works correclty', () {
      final challenge = ChallengeWithProgress(
          challenge: Challenge(
              id: "id",
              name: "name",
              description: "description",
              icon: "icon",
              category: ChallengeCategory.daily_sessions,
              reward_xp: 0,
              is_repeatable: true,
              condition_amount: 60,
              difficulty: 2));

      final sourceState = ChallengeState.initial();
      final newState = sourceState.copyWith(
          status: Status.loading,
          challenges: [challenge],
          selectedCategory: ChallengeCategory.streak_days);

      expect(newState.challenges, [challenge]);
      expect(newState.status, Status.loading);
      expect(newState.selectedCategory, ChallengeCategory.streak_days);
    });
  });
}
