import 'package:bloc_test/bloc_test.dart';
import 'package:challenge_repository/challenge_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/ui/stats/todays_achievement.dart';
import 'package:mocktail/mocktail.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:challenge_repository/challenge.dart';
import 'package:challenge_repository/challenge_repository.dart';

class MockChallengeBloc extends MockBloc<ChallengeEvent, ChallengeState>
    implements ChallengeBloc {}

void main() {
  late MockChallengeBloc mockBloc;

  setUp(() {
    mockBloc = MockChallengeBloc();
  });

  Widget buildWidget({required ChallengeState state}) {
    when(() => mockBloc.state).thenReturn(state);

    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<ChallengeBloc>.value(
          value: mockBloc,
          child: TodaysAchievements(todaysSessions: 3, todaysStudyTime: 60),
        ),
      ),
    );
  }

  testWidgets('renders today\'s duration and session count', (tester) async {
    final state = ChallengeState.initial()
        .copyWith(status: Status.loaded, challenges: []);

    await tester.pumpWidget(buildWidget(state: state));

    expect(find.text('Duration'), findsOneWidget);
    expect(find.text('Sessions'), findsOneWidget);
    expect(find.text('3'), findsOneWidget); // sessions
    expect(find.textContaining('1 h'), findsOneWidget); // 75 minutes
  });

  testWidgets('shows no challenges completed today message', (tester) async {
    final state = ChallengeState.initial()
        .copyWith(status: Status.loaded, challenges: []);

    await tester.pumpWidget(buildWidget(state: state));

    expect(find.text('No challenges completed today.'), findsOneWidget);
  });

  testWidgets('renders completed challenges from today', (tester) async {
    final today = DateTime.now();
    final todayStr = DateTime(today.year, today.month, today.day)
        .toIso8601String()
        .split('T')
        .first;

    final challenge = Challenge(
      id: '1',
      name: 'Finish something',
      description: 'Do something great',
      icon: '🔥',
      category: ChallengeCategory.daily_sessions,
      reward_xp: 100,
      is_repeatable: false,
      condition_amount: 1,
      difficulty: 1,
    );

    final progress = ChallengeProgress(
      challenge_id: '1',
      completed: true,
      progress: 1,
      last_updated: DateTime.parse('${todayStr}T12:00:00Z'), // today
    );

    final challengeWithProgress = ChallengeWithProgress(
      challenge: challenge,
      progress: progress,
    );

    final state = ChallengeState.initial().copyWith(
      status: Status.loaded,
      challenges: [challengeWithProgress],
    );

    await tester.pumpWidget(buildWidget(state: state));

    expect(find.text('Completed Challenges'), findsOneWidget);
    expect(find.text('🔥'), findsOneWidget);
    expect(find.text('Finish something'), findsOneWidget);
    expect(find.text('100 XP'), findsOneWidget);
  });

  testWidgets('renders nothing when status is loading or initial',
      (tester) async {
    for (final status in [Status.loading, Status.initial]) {
      final state =
          ChallengeState.initial().copyWith(status: status, challenges: []);
      await tester.pumpWidget(buildWidget(state: state));

      expect(find.text('Completed Challenges'), findsNothing);
      expect(find.text('No challenges completed today.'), findsNothing);
    }
  });
}
