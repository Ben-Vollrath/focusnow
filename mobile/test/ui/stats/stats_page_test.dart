import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:focusnow/ui/stats/level_box.dart';
import 'package:focusnow/ui/stats/study_chart.dart';
import 'package:focusnow/ui/stats/todays_achievement.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/ui/stats/stats_page.dart';
import 'package:stats_repository/daily_study_data.dart';
import 'package:stats_repository/stats_repository.dart';
import 'package:stats_repository/user_stats.dart';

class MockStatsBloc extends MockBloc<StatsEvent, StatsState>
    implements StatsBloc {}

class MockChallengeBloc extends MockBloc<ChallengeEvent, ChallengeState>
    implements ChallengeBloc {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  setUpAll(() {
    AnalyticsRepository.setInstance(MockAnalyticsRepository());
  });

  late MockStatsBloc mockBloc;
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
      totalStudyTime: i == 6 ? 90 : 60,
      totalStudySessions: i == 6 ? 3 : 2,
      streakDay: i,
    );
  });

  final userStats = UserStats(
    level: 5,
    xp: 1200,
    xpToNext: 1500,
    levelName: 'Focused Fox',
    levelIcon: '🦊',
    totalStudyTime: 6000,
    totalStudySessions: 100,
  );

  Widget buildWidget({
    required StatsState statsState,
  }) {
    when(() => mockBloc.state).thenReturn(statsState);
    when(() => mockChallengeBloc.state).thenReturn(
      ChallengeState.initial().copyWith(status: Status.loaded, challenges: []),
    );

    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<StatsBloc>.value(value: mockBloc),
          BlocProvider<ChallengeBloc>.value(value: mockChallengeBloc),
        ],
        child: const StatsPage(),
      ),
    );
  }

  setUp(() {
    mockBloc = MockStatsBloc();
    mockChallengeBloc = MockChallengeBloc();
  });

  testWidgets('shows loading spinner when status is loading', (tester) async {
    when(() => mockBloc.state)
        .thenReturn(const StatsState(status: StatsStatus.loading));

    await tester.pumpWidget(buildWidget(statsState: mockBloc.state));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when status is failure', (tester) async {
    when(() => mockBloc.state).thenReturn(const StatsState(
      status: StatsStatus.failure,
      errorMessage: 'Something went wrong',
    ));

    await tester.pumpWidget(buildWidget(statsState: mockBloc.state));
    expect(find.textContaining('Error: Something went wrong'), findsOneWidget);
  });

  testWidgets('renders all stat widgets when loaded', (tester) async {
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
    expect(find.byType(StreakBadge), findsOneWidget);
  });

  testWidgets('calculates and passes correct streak to StreakBadge',
      (tester) async {
    // Simulate a streak of 7 days with non-zero study time
    final fullStreakData = [
      DailyStudyData(
        studyDate: DateTime.now().toIso8601String().split('T').first,
        totalStudyTime: 30,
        totalStudySessions: 2,
        streakDay: 7,
      ),
    ];

    final state = StatsState(
      status: StatsStatus.success,
      userStats: userStats,
      weeklyStudyData: fullStreakData,
      levels: [],
    );

    await tester.pumpWidget(buildWidget(statsState: state));

    expect(find.text('7'), findsOneWidget); // Streak count shown in badge
  });
}
