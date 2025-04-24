import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:focusnow/bloc/goal/goal_bloc.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/ui/stats/stats_share_view.dart';
import 'package:focusnow/ui/stats/goal_box.dart';
import 'package:focusnow/ui/stats/level_box.dart';
import 'package:focusnow/ui/stats/study_chart.dart';
import 'package:focusnow/ui/stats/todays_achievement.dart';
import 'package:goal_repository/goal.dart';
import 'package:stats_repository/daily_study_data.dart';
import 'package:stats_repository/user_stats.dart';
import 'package:mocktail/mocktail.dart';

class MockStatsBloc extends MockBloc<StatsEvent, StatsState>
    implements StatsBloc {}

class MockGoalBloc extends MockBloc<GoalEvent, GoalState> implements GoalBloc {}

class MockChallengeBloc extends MockBloc<ChallengeEvent, ChallengeState>
    implements ChallengeBloc {}

void main() {
  late MockStatsBloc mockStatsBloc;
  late MockGoalBloc mockGoalBloc;
  late MockChallengeBloc mockChallengeBloc;

  final today = DateTime.now();
  final todayStr = DateTime(today.year, today.month, today.day)
      .toIso8601String()
      .split('T')
      .first;

  final weeklyData = List.generate(7, (i) {
    final date = today.subtract(Duration(days: 6 - i));
    return DailyStudyData(
      studyDate: date.toIso8601String().split('T').first,
      totalStudyTime: 60,
      totalStudySessions: 2,
      streakDay: i,
    );
  });

  final userStats = UserStats(
    level: 3,
    xp: 800,
    xpToNext: 1000,
    levelName: 'Mindful Moose',
    levelIcon: '🦌',
    totalStudyTime: 3200,
    totalStudySessions: 60,
  );

  setUp(() {
    mockStatsBloc = MockStatsBloc();
    mockGoalBloc = MockGoalBloc();
    mockChallengeBloc = MockChallengeBloc();
  });

  Widget buildWidget({required StatsState statsState}) {
    when(() => mockStatsBloc.state).thenReturn(statsState);
    when(() => mockGoalBloc.state).thenReturn(
      GoalState.initial().copyWith(
        status: GoalStatus.loaded,
        goal: Goal(
          id: "goal-id",
          name: "Deep Focus",
          targetMinutes: 100,
          currentMinutes: 50,
          xpReward: 20,
          createdAt: DateTime(2024),
          targetDate: DateTime(2025),
          completed: false,
        ),
      ),
    );

    when(() => mockChallengeBloc.state).thenReturn(
      ChallengeState.initial().copyWith(status: Status.loaded, challenges: []),
    );

    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ChallengeBloc>.value(value: mockChallengeBloc),
          BlocProvider<StatsBloc>.value(value: mockStatsBloc),
          BlocProvider<GoalBloc>.value(value: mockGoalBloc),
        ],
        child: const StatsShareView(),
      ),
    );
  }

  testWidgets('shows loading spinner when status is loading', (tester) async {
    when(() => mockStatsBloc.state).thenReturn(
      const StatsState(status: StatsStatus.loading),
    );

    await tester.pumpWidget(buildWidget(statsState: mockStatsBloc.state));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when status is failure', (tester) async {
    when(() => mockStatsBloc.state).thenReturn(
      const StatsState(
        status: StatsStatus.failure,
        errorMessage: 'Oops!',
      ),
    );

    await tester.pumpWidget(buildWidget(statsState: mockStatsBloc.state));
    expect(find.textContaining('Error: Oops!'), findsOneWidget);
  });

  testWidgets('renders share view components when loaded', (tester) async {
    final state = StatsState(
      status: StatsStatus.success,
      userStats: userStats,
      weeklyStudyData: weeklyData,
      levels: [],
    );

    await tester.pumpWidget(buildWidget(statsState: state));

    expect(find.byType(LevelBox), findsOneWidget);
    expect(find.byType(StudyChart), findsOneWidget);
    expect(find.byType(TodaysAchievements), findsOneWidget);
    expect(find.text('FocusNow'), findsOneWidget);
  });

  testWidgets('does not show GoalBox if goal is null', (tester) async {
    when(() => mockStatsBloc.state).thenReturn(
      StatsState(
        status: StatsStatus.success,
        userStats: userStats,
        weeklyStudyData: weeklyData,
        levels: [],
      ),
    );
    when(() => mockGoalBloc.state).thenReturn(
      GoalState.initial().copyWith(status: GoalStatus.loaded, goal: null),
    );

    await tester.pumpWidget(buildWidget(statsState: mockStatsBloc.state));

    expect(find.byType(GoalBox), findsNothing);
  });
}
