import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:challenge_repository/challenge_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/ui/challenges/challenge_tile.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:focusnow/ui/challenges/challenges_page.dart';
import 'package:challenge_repository/challenge.dart';
import 'package:challenge_repository/challenge_repository.dart';

class MockChallengeBloc extends MockBloc<ChallengeEvent, ChallengeState>
    implements ChallengeBloc {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  setUpAll(() {
    AnalyticsRepository.setInstance(MockAnalyticsRepository());
  });

  late MockChallengeBloc mockBloc;

  final testChallenge = Challenge(
    id: '1',
    name: 'Do it!',
    description: 'Test challenge',
    icon: '🔥',
    category: ChallengeCategory.streak_days,
    reward_xp: 100,
    is_repeatable: false,
    condition_amount: 10,
    difficulty: 1,
  );

  ChallengeWithProgress withProgress(bool completed) => ChallengeWithProgress(
        challenge: testChallenge,
        progress: completed
            ? ChallengeProgress(
                challenge_id: testChallenge.id,
                progress: 10,
                completed: true,
                last_updated: DateTime.now(),
              )
            : ChallengeProgress(
                challenge_id: testChallenge.id,
                progress: 5,
                completed: false,
                last_updated: DateTime.now(),
              ),
      );

  Widget buildPage() {
    return MaterialApp(
      home: BlocProvider<ChallengeBloc>.value(
        value: mockBloc,
        child: const ChallengesPage(),
      ),
    );
  }

  setUp(() {
    mockBloc = MockChallengeBloc();
  });

  testWidgets('shows CircularProgressIndicator when loading', (tester) async {
    when(() => mockBloc.state).thenReturn(
      ChallengeState.initial().copyWith(status: Status.loading),
    );

    await tester.pumpWidget(buildPage());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty message when loaded but no challenges',
      (tester) async {
    when(() => mockBloc.state).thenReturn(
      ChallengeState.initial().copyWith(status: Status.loaded, challenges: []),
    );

    await tester.pumpWidget(buildPage());
    expect(find.text('No challenges found.'), findsOneWidget);
  });

  testWidgets('shows error message when status is error', (tester) async {
    when(() => mockBloc.state).thenReturn(
      ChallengeState.initial().copyWith(status: Status.error),
    );

    await tester.pumpWidget(buildPage());
    expect(find.text('Failed to load challenges.'), findsOneWidget);
  });

  testWidgets('shows list of challenge tiles and correct completed counter',
      (tester) async {
    final challenges = [
      withProgress(true),
      withProgress(false),
    ];

    when(() => mockBloc.state).thenReturn(
      ChallengeState.initial()
          .copyWith(status: Status.loaded, challenges: challenges),
    );

    await tester.pumpWidget(buildPage());

    expect(find.byType(ChallengeTile), findsNWidgets(2));
    expect(find.text('Completed: 1 / 2'), findsOneWidget);
  });
}
