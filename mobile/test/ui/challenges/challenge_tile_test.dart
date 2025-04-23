import 'package:challenge_repository/challenge_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:challenge_repository/challenge.dart';
import 'package:challenge_repository/challenge_progress.dart';
import 'package:focusnow/ui/challenges/challenge_tile.dart';
import 'package:focusnow/ui/widgets/rounded_progress_indicator.dart';

void main() {
  final challenge1 = Challenge(
    id: '1',
    name: 'Study for 60 mins',
    description: 'Total study time',
    icon: '📚',
    category: ChallengeCategory.daily_sessions,
    reward_xp: 100,
    is_repeatable: false,
    condition_amount: 5,
    difficulty: 1,
  );

  final challenge2 = Challenge(
    id: '1',
    name: 'Study for 60 mins',
    description: 'Total study time',
    icon: '📚',
    category: ChallengeCategory.total_hours,
    reward_xp: 100,
    is_repeatable: false,
    condition_amount: 60,
    difficulty: 1,
  );

  group('ChallengeTile', () {
    testWidgets(
        'shows unlocked progress view with challenge info for daily sessions',
        (tester) async {
      final progress = ChallengeProgress(
        challenge_id: '1',
        progress: 1,
        completed: false,
        last_updated: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChallengeTile(
              entry: ChallengeWithProgress(
                  challenge: challenge1, progress: progress),
            ),
          ),
        ),
      );

      expect(find.text('📚'), findsOneWidget);
      expect(find.text('Study for 60 mins'), findsOneWidget);
      expect(find.text('100 XP'), findsOneWidget);
      expect(find.text('Total study time'), findsOneWidget);
      expect(find.text('1 / 5'), findsOneWidget);
      expect(find.byType(ChallengeProgressText), findsOneWidget);
    });

    testWidgets(
        'shows unlocked progress view with challenge info for category with time',
        (tester) async {
      final progress = ChallengeProgress(
        challenge_id: '1',
        progress: 30,
        completed: false,
        last_updated: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChallengeTile(
              entry: ChallengeWithProgress(
                  challenge: challenge2, progress: progress),
            ),
          ),
        ),
      );

      expect(find.text('📚'), findsOneWidget);
      expect(find.text('Study for 60 mins'), findsOneWidget);
      expect(find.text('100 XP'), findsOneWidget);
      expect(find.text('Total study time'), findsOneWidget);
      expect(find.text('30 m'), findsOneWidget);
      expect(find.text(' / '), findsOneWidget);
      expect(find.text('1 h'), findsOneWidget);
      expect(find.byType(ChallengeProgressText), findsOneWidget);
    });

    testWidgets('shows locked challenge when no progress is provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChallengeTile(
              entry:
                  ChallengeWithProgress(challenge: challenge1, progress: null),
            ),
          ),
        ),
      );

      expect(find.text('📚'), findsOneWidget);
      expect(find.text('Study for 60 mins'), findsOneWidget);
      expect(find.text('100 XP'), findsOneWidget);
      expect(find.text('Locked'), findsOneWidget);
      expect(find.byType(RoundedProgressIndicator), findsOneWidget);
    });
  });
}
