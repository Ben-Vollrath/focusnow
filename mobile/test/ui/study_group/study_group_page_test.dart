import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:focusnow/bloc/study_group/study_group_bloc.dart';
import 'package:focusnow/ui/study_group/study_group_page.dart';
import 'package:study_group_repository/study_group.dart';
import 'package:study_group_repository/study_group_repository.dart';

class MockStudyGroupBloc extends MockBloc<StudyGroupEvent, StudyGroupState>
    implements StudyGroupBloc {}

void main() {
  late MockStudyGroupBloc mockBloc;

  final studyGroup = StudyGroup(
    id: 'group-1',
    name: 'Group 1',
    description: 'desc',
    isPublic: true,
    createdAt: DateTime.now(),
    memberCount: 2,
    goal: null,
    isJoined: false,
    ownerId: '',
  );

  setUp(() {
    mockBloc = MockStudyGroupBloc();
    when(() => mockBloc.stream)
        .thenAnswer((_) => const Stream<StudyGroupState>.empty());
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<StudyGroupBloc>(
        create: (_) => mockBloc,
        child: const StudyGroupPage(),
      ),
    );
  }

  testWidgets('shows loading indicator when loading and no groups',
      (tester) async {
    when(() => mockBloc.state).thenReturn(
      StudyGroupState().copyWith(isLoading: true, groups: []),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when error is present', (tester) async {
    when(() => mockBloc.state).thenReturn(
      StudyGroupState().copyWith(error: 'Something went wrong'),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.textContaining('Error:'), findsOneWidget);
  });

  testWidgets('shows group list when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(
      StudyGroupState().copyWith(groups: [studyGroup]),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Group 1'), findsOneWidget); // From GroupTile
  });

  testWidgets('tapping Only Joined chip dispatches ChangeShowJoined event',
      (tester) async {
    when(() => mockBloc.state).thenReturn(
      StudyGroupState().copyWith(showJoined: false),
    );

    await tester.pumpWidget(makeTestableWidget());

    await tester.tap(find.byType(ChoiceChip));
    await tester.pump();

    verify(() => mockBloc.add(ChangeShowJoined(showJoined: true))).called(1);
  });

  testWidgets('tapping sort icon toggles sort order', (tester) async {
    when(() => mockBloc.state).thenReturn(
      StudyGroupState().copyWith(ascending: false),
    );

    await tester.pumpWidget(makeTestableWidget());

    await tester.tap(find.byIcon(Icons.arrow_downward));
    await tester.pump();

    verify(() => mockBloc.add(ChangeGroupSortOrder(ascending: true))).called(1);
  });

  testWidgets('changing dropdown sends ChangeGroupSortBy event',
      (tester) async {
    when(() => mockBloc.state).thenReturn(
      StudyGroupState().copyWith(sortBy: StudyGroupSortBy.createdAt),
    );

    await tester.pumpWidget(makeTestableWidget());

    await tester.tap(find.byType(DropdownButton<StudyGroupSortBy>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Member Count').last);
    await tester.pump();

    verify(() => mockBloc.add(
        ChangeGroupSortBy(sortBy: StudyGroupSortBy.memberCount))).called(1);
  });
}
