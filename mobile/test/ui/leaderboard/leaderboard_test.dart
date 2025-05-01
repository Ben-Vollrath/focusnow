import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/bloc/leaderboard/leaderboard_bloc.dart';
import 'package:focusnow/ui/leaderboard/leaderboard_page.dart';
import 'package:leaderboard_repository/leaderboard_entry.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockLeaderboardBloc extends MockBloc<LeaderboardEvent, LeaderboardState>
    implements LeaderboardBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  late MockLeaderboardBloc mockLeaderboardBloc;
  late MockAppBloc mockAppBloc;

  setUp(() {
    mockLeaderboardBloc = MockLeaderboardBloc();
    mockAppBloc = MockAppBloc();
  });

  testWidgets('displays loading indicator', (tester) async {
    when(() => mockLeaderboardBloc.state).thenReturn(
      LeaderboardState.initial().copyWith(status: LeaderBoardStatus.loading),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<LeaderboardBloc>.value(value: mockLeaderboardBloc),
            BlocProvider<AppBloc>.value(value: mockAppBloc),
          ],
          child: const LeaderboardPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays error message on error state', (tester) async {
    when(() => mockLeaderboardBloc.state).thenReturn(
      LeaderboardState.initial().copyWith(status: LeaderBoardStatus.error),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<LeaderboardBloc>.value(value: mockLeaderboardBloc),
            BlocProvider<AppBloc>.value(value: mockAppBloc),
          ],
          child: const LeaderboardPage(),
        ),
      ),
    );

    expect(find.text('Failed to load leaderboard'), findsOneWidget);
  });

  testWidgets('renders leaderboard entries', (tester) async {
    final testEntry = LeaderboardEntry(
      userId: 'u1',
      name: 'User One',
      totalStudyTime: 50,
      totalStudySessions: 4,
      rank: 1,
      isCurrentUser: true,
    );

    when(() => mockLeaderboardBloc.state).thenReturn(
      LeaderboardState.initial().copyWith(
        status: LeaderBoardStatus.loaded,
        dailyLeaderboard: [testEntry],
        totalLeaderboard: [],
        selectedType: LeaderboardType.daily,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<LeaderboardBloc>.value(value: mockLeaderboardBloc),
            BlocProvider<AppBloc>.value(value: mockAppBloc),
          ],
          child: const LeaderboardPage(),
        ),
      ),
    );

    expect(find.text('User One'), findsOneWidget);
    expect(find.text('50 m'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });
}
