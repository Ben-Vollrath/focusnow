import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/ui/leaderboard/leaderboard_tile.dart';
import 'package:focusnow/ui/study_group/goal_leaderboard_tile.dart';
import 'package:mocktail/mocktail.dart';
import 'package:focusnow/bloc/study_group/study_group_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/ui/study_group/study_group_detail_page.dart';
import 'package:study_group_repository/goal.dart';
import 'package:study_group_repository/goal_leaderboard_entry.dart';
import 'package:study_group_repository/leaderboard_entry.dart';
import 'package:study_group_repository/study_group.dart';

class MockStudyGroupBloc extends MockBloc<StudyGroupEvent, StudyGroupState>
    implements StudyGroupBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  late MockStudyGroupBloc mockStudyGroupBloc;
  late MockAppBloc mockAppBloc;

  final testGroup = StudyGroup(
    id: 'group-1',
    name: 'Focus Group',
    description: 'Test description',
    isPublic: true,
    createdAt: DateTime.now(),
    memberCount: 5,
    goal: Goal(
      id: 'test-id',
      createdAt: DateTime.now(),
      currentMinutes: 50,
      completed: false,
      name: 'Test Goal',
      description: 'Goal description',
      targetMinutes: 120,
      xpReward: 100,
      targetDate: DateTime(2025, 6, 1),
    ),
    isJoined: true,
    ownerId: 'owner-id',
  );

  setUp(() {
    mockStudyGroupBloc = MockStudyGroupBloc();
    mockAppBloc = MockAppBloc();

    when(() => mockStudyGroupBloc.stream)
        .thenAnswer((_) => const Stream<StudyGroupState>.empty());
    when(() => mockAppBloc.stream)
        .thenAnswer((_) => const Stream<AppState>.empty());

    when(() => mockAppBloc.state).thenReturn(AppState.authenticated(
        User(id: 'owner-id', name: 'Test User', email: '')));
    when(() => mockStudyGroupBloc.state).thenReturn(
      StudyGroupState().copyWith(
        selectedGroup: testGroup,
        goalLeaderboard: [
          GoalLeaderboardEntry(
            userId: 'user-1',
            userName: 'Alice',
            currentMinutes: 100,
          ),
        ],
        dailyLeaderboard: [],
        totalLeaderboard: [],
      ),
    );
  });

  Widget buildPage() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<StudyGroupBloc>.value(value: mockStudyGroupBloc),
          BlocProvider<AppBloc>.value(value: mockAppBloc),
        ],
        child: StudyGroupDetailPage(),
      ),
    );
  }

  testWidgets('renders group name, description and goal info', (tester) async {
    await tester.pumpWidget(buildPage());

    expect(find.text('Focus Group'), findsOneWidget);
    expect(find.text('Test description'), findsOneWidget);
    expect(find.text('Test Goal'), findsOneWidget);
    expect(find.text('Goal description'), findsOneWidget);
    expect(find.text('100 XP'), findsOneWidget);
  });

  testWidgets('shows goal leaderboard by default if group has a goal',
      (tester) async {
    await tester.pumpWidget(buildPage());

    expect(find.text('Alice'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(3));
    expect(find.widgetWithText(ChoiceChip, 'Goal'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Daily'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Total'), findsOneWidget);
  });

  testWidgets('doesnt show goal leaderboard if group has no goal',
      (tester) async {
    when(() => mockStudyGroupBloc.state).thenReturn(
      StudyGroupState().copyWith(
        selectedGroup: StudyGroup(
          id: 'group-1',
          name: 'Focus Group',
          description: 'Test description',
          isPublic: true,
          createdAt: DateTime.now(),
          memberCount: 5,
          goal: null,
          isJoined: false,
          ownerId: 'owner-id123',
        ),
        goalLeaderboard: [],
        dailyLeaderboard: [],
        totalLeaderboard: [],
      ),
    );
    await tester.pumpWidget(buildPage());

    expect(find.byType(ChoiceChip), findsNWidgets(2));
    expect(find.widgetWithText(ChoiceChip, 'Goal'), findsNothing);
    expect(find.widgetWithText(ChoiceChip, 'Daily'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Total'), findsOneWidget);
  });

  testWidgets('shows goal leaderboard tile', (tester) async {
    await tester.pumpWidget(buildPage());

    expect(find.byType(GoalLeaderboardTile), findsOneWidget);
  });

  testWidgets('shows leaderboard tile', (tester) async {
    when(() => mockStudyGroupBloc.state).thenReturn(
      StudyGroupState().copyWith(
        selectedGroup: StudyGroup(
          id: 'group-1',
          name: 'Focus Group',
          description: 'Test description',
          isPublic: true,
          createdAt: DateTime.now(),
          memberCount: 5,
          goal: null,
          isJoined: false,
          ownerId: 'owner-id123',
        ),
        goalLeaderboard: [],
        dailyLeaderboard: [
          StudyGroupLeaderboardEntry(
              userId: "test-id",
              userName: "username",
              totalStudyTime: 10,
              totalStudySessions: 12,
              rank: 1)
        ],
        totalLeaderboard: [],
      ),
    );

    await tester.pumpWidget(buildPage());

    expect(find.byType(LeaderboardTile), findsOneWidget);
  });

  testWidgets('tapping login icon triggers JoinStudyGroup', (tester) async {
    when(() => mockStudyGroupBloc.state).thenReturn(
      StudyGroupState().copyWith(
        selectedGroup: StudyGroup(
          id: 'group-1',
          name: 'Focus Group',
          description: 'Test description',
          isPublic: true,
          createdAt: DateTime.now(),
          memberCount: 5,
          goal: Goal(
            id: 'test-id',
            createdAt: DateTime.now(),
            currentMinutes: 50,
            completed: false,
            name: 'Test Goal',
            description: 'Goal description',
            targetMinutes: 120,
            xpReward: 100,
            targetDate: DateTime(2025, 6, 1),
          ),
          isJoined: false,
          ownerId: 'owner-id123',
        ),
        goalLeaderboard: [
          GoalLeaderboardEntry(
            userId: 'user-1',
            userName: 'Alice',
            currentMinutes: 100,
          ),
        ],
        dailyLeaderboard: [],
        totalLeaderboard: [],
      ),
    );

    await tester.pumpWidget(buildPage());

    await tester.tap(find.byIcon(Icons.login));
    await tester.pump();

    verify(() => mockStudyGroupBloc.add(JoinStudyGroup())).called(1);
  });

  testWidgets('tapping logout icon triggers LeaveStudyGroup', (tester) async {
    await tester.pumpWidget(buildPage());

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pump();

    verify(() => mockStudyGroupBloc.add(LeaveStudyGroup())).called(1);
  });

  testWidgets('tapping share button dispatches ShareGroup', (tester) async {
    await tester.pumpWidget(buildPage());

    await tester.tap(find.widgetWithText(FilledButton, 'Share'));
    await tester.pump();

    verify(() => mockStudyGroupBloc.add(ShareGroup())).called(1);
  });

  testWidgets('tapping delete icon dispatches DeleteGroupGoal', (tester) async {
    await tester.pumpWidget(buildPage());

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    verify(() => mockStudyGroupBloc.add(DeleteGroupGoal())).called(1);
  });
}
