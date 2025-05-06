import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:study_group_repository/goal_leaderboard_entry.dart';
import 'package:study_group_repository/input_goal.dart';
import 'package:study_group_repository/study_group.dart';
import 'package:study_group_repository/study_group_repository.dart';
import 'package:focusnow/bloc/study_group/study_group_bloc.dart';

class MockStudyGroupRepository extends Mock implements StudyGroupRepository {}

void main() {
  late StudyGroupBloc bloc;
  late MockStudyGroupRepository repository;

  final studyGroup = StudyGroup(
      id: 'group-1',
      name: 'Group 1',
      description: 'desc',
      isPublic: true,
      createdAt: DateTime.now(),
      memberCount: 2,
      goal: null,
      isJoined: false,
      ownerId: '');
  final studyGroup2 = StudyGroup(
      id: 'group-2',
      name: 'Group 2',
      description: 'desc',
      isPublic: true,
      createdAt: DateTime.now(),
      memberCount: 2,
      goal: null,
      isJoined: false,
      ownerId: '');
  final groupList = [studyGroup];

  final goalLeaderboard = [
    GoalLeaderboardEntry(
        userId: 'user-1', userName: 'testuser', currentMinutes: 100),
  ];

  final inputGoal = InputGoal(
      targetDate: DateTime.now(),
      targetMinutes: 100,
      name: '',
      description: '');

  setUp(() {
    repository = MockStudyGroupRepository();
    bloc = StudyGroupBloc(repository);
    when(() => repository.fetchStudyGroups()).thenAnswer((_) async => []);
    when(() => repository.fetchStudyGroup(any())).thenAnswer((_) async => null);
  });

  group('StudyGroupBloc', () {
    group('FetchStudyGroups', () {
      blocTest<StudyGroupBloc, StudyGroupState>(
        'calls fetchStudyGroups (not joined) and emits loading then loaded',
        build: () {
          when(() => repository.fetchStudyGroups())
              .thenAnswer((_) async => groupList);
          return StudyGroupBloc(repository);
        },
        seed: () => StudyGroupState().copyWith(showJoined: false),
        act: (bloc) => bloc.add(FetchStudyGroups()),
        expect: () => [
          StudyGroupState().copyWith(showJoined: false, isLoading: true),
          StudyGroupState().copyWith(
            showJoined: false,
            groups: groupList,
            isLoading: false,
            endOfListReached: false,
          ),
        ],
        verify: (_) => verify(() => repository.fetchStudyGroups()).called(1),
      );

      blocTest<StudyGroupBloc, StudyGroupState>(
        'calls fetchJoinedStudyGroups (joined=true) and emits loading then loaded',
        build: () {
          when(() => repository.fetchJoinedStudyGroups())
              .thenAnswer((_) async => groupList);
          return StudyGroupBloc(repository);
        },
        seed: () => StudyGroupState().copyWith(showJoined: true),
        act: (bloc) => bloc.add(FetchStudyGroups()),
        expect: () => [
          StudyGroupState().copyWith(showJoined: true, isLoading: true),
          StudyGroupState().copyWith(
            showJoined: true,
            groups: groupList,
            isLoading: false,
            endOfListReached: false,
          ),
        ],
        verify: (_) =>
            verify(() => repository.fetchJoinedStudyGroups()).called(1),
      );

      blocTest<StudyGroupBloc, StudyGroupState>(
        'appends to groups when isNextPage = true',
        build: () {
          when(() => repository.fetchStudyGroups())
              .thenAnswer((_) async => groupList);
          return StudyGroupBloc(repository);
        },
        seed: () => StudyGroupState()
            .copyWith(groups: [studyGroup2], showJoined: false),
        act: (bloc) => bloc.add(FetchStudyGroups(isNextPage: true)),
        expect: () => [
          StudyGroupState().copyWith(
            groups: [studyGroup2],
            page: 0,
            isLoading: true,
          ),
          StudyGroupState().copyWith(
            groups: [
              studyGroup2,
              ...groupList,
            ],
            page: 0,
            isLoading: false,
            endOfListReached: false,
          ),
        ],
        verify: (_) => verify(() => repository.fetchStudyGroups()).called(1),
      );

      blocTest<StudyGroupBloc, StudyGroupState>(
        'emits [loading, error] when fetchStudyGroups throws',
        build: () {
          when(() => repository.fetchStudyGroups())
              .thenThrow(Exception('fail'));
          return StudyGroupBloc(repository);
        },
        seed: () => StudyGroupState().copyWith(showJoined: false),
        act: (bloc) => bloc.add(FetchStudyGroups()),
        expect: () => [
          StudyGroupState().copyWith(showJoined: false, isLoading: true),
          StudyGroupState().copyWith(
            showJoined: false,
            isLoading: false,
            error: 'Exception: fail',
          ),
        ],
      );
    });

    blocTest<StudyGroupBloc, StudyGroupState>(
      'calls createStudyGroup and fetches groups after CreateStudyGroup',
      build: () {
        when(() => repository.createStudyGroup(
            name: 'Group',
            description: 'desc',
            isPublic: true)).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(
          CreateStudyGroup(name: 'Group', description: 'desc', isPublic: true)),
      expect: () => [
        StudyGroupState().copyWith(isLoading: true),
        StudyGroupState()
            .copyWith(groups: [], isLoading: false, endOfListReached: true),
      ],
      verify: (_) {
        verify(() => repository.createStudyGroup(
            name: 'Group', description: 'desc', isPublic: true)).called(1);
        verify(() => repository.fetchStudyGroups()).called(1);
      },
    );

    blocTest<StudyGroupBloc, StudyGroupState>(
      'Join Study Group',
      build: () {
        when(() => repository.joinStudyGroup(studyGroup.id))
            .thenAnswer((_) async {});
        return bloc;
      },
      seed: () => StudyGroupState().copyWith(selectedGroup: studyGroup),
      act: (bloc) => bloc.add(JoinStudyGroup()),
      verify: (_) {
        verify(() => repository.joinStudyGroup(studyGroup.id)).called(1);
        verify(() => repository.fetchStudyGroups()).called(1);
      },
    );

    blocTest<StudyGroupBloc, StudyGroupState>(
      'Leave Study Group',
      build: () {
        when(() => repository.leaveStudyGroup(studyGroup.id))
            .thenAnswer((_) async {});
        return bloc;
      },
      seed: () => StudyGroupState().copyWith(selectedGroup: studyGroup),
      act: (bloc) => bloc.add(LeaveStudyGroup()),
      verify: (_) {
        verify(() => repository.leaveStudyGroup(studyGroup.id)).called(1);
        verify(() => repository.fetchStudyGroups()).called(1);
      },
    );

    blocTest<StudyGroupBloc, StudyGroupState>(
      'Create Group Goal',
      build: () {
        when(() => repository.createStudyGroupGoal(
              goal: inputGoal,
              studyGroupId: studyGroup.id,
            )).thenAnswer((_) async {});
        return bloc;
      },
      seed: () => StudyGroupState().copyWith(selectedGroup: studyGroup),
      act: (bloc) => bloc.add(CreateGroupGoal(inputGoal: inputGoal)),
      verify: (_) {
        verify(() => repository.createStudyGroupGoal(
              goal: inputGoal,
              studyGroupId: studyGroup.id,
            )).called(1);
        verify(() => repository.fetchStudyGroups()).called(1);
        verify(() => repository.fetchStudyGroup(studyGroup.id)).called(1);
      },
    );

    blocTest<StudyGroupBloc, StudyGroupState>(
      'FetchLeaderboards calls all leaderboard methods and updates state',
      build: () {
        when(() => repository.fetchGroupMemberDailyLeaderboard(studyGroup.id))
            .thenAnswer((_) async => []);
        when(() => repository.fetchGroupMemberTotalLeaderboard(studyGroup.id))
            .thenAnswer((_) async => []);
        when(() => repository.fetchGroupMemberGoalLeaderboard(studyGroup.id))
            .thenAnswer((_) async => goalLeaderboard);
        return StudyGroupBloc(repository);
      },
      seed: () => StudyGroupState().copyWith(selectedGroup: studyGroup),
      act: (bloc) => bloc.add(FetchLeaderboards()),
      expect: () => [
        StudyGroupState().copyWith(selectedGroup: studyGroup, isLoading: true),
        StudyGroupState().copyWith(
          selectedGroup: studyGroup,
          isLoading: false,
          dailyLeaderboard: [],
          totalLeaderboard: [],
          goalLeaderboard: goalLeaderboard,
        ),
      ],
      verify: (_) {
        verify(() => repository.fetchGroupMemberDailyLeaderboard(studyGroup.id))
            .called(1);
        verify(() => repository.fetchGroupMemberTotalLeaderboard(studyGroup.id))
            .called(1);
        verify(() => repository.fetchGroupMemberGoalLeaderboard(studyGroup.id))
            .called(1);
      },
    );

    blocTest<StudyGroupBloc, StudyGroupState>(
      'ChangeGroupSortBy updates sortBy and fetches groups',
      build: () {
        when(() => repository.fetchStudyGroups(
              page: 0,
              sortBy: StudyGroupSortBy.memberCount,
              ascending: any(named: 'ascending'),
            )).thenAnswer((_) async => groupList);
        return StudyGroupBloc(repository);
      },
      act: (bloc) =>
          bloc.add(ChangeGroupSortBy(sortBy: StudyGroupSortBy.memberCount)),
      expect: () => [
        StudyGroupState().copyWith(
          sortBy: StudyGroupSortBy.memberCount,
          endOfListReached: false,
          page: 0,
        ),
        StudyGroupState().copyWith(
          sortBy: StudyGroupSortBy.memberCount,
          endOfListReached: false,
          page: 0,
          isLoading: true,
        ),
        StudyGroupState().copyWith(
          sortBy: StudyGroupSortBy.memberCount,
          endOfListReached: false,
          page: 0,
          groups: groupList,
          isLoading: false,
        ),
      ],
      verify: (_) {
        verify(() => repository.fetchStudyGroups(
              page: 0,
              sortBy: StudyGroupSortBy.memberCount,
              ascending: any(named: 'ascending'),
            )).called(1);
      },
    );

    blocTest<StudyGroupBloc, StudyGroupState>(
      'ChangeShowJoined updates flag and fetches groups',
      build: () {
        when(() => repository.fetchJoinedStudyGroups())
            .thenAnswer((_) async => groupList);
        return StudyGroupBloc(repository);
      },
      act: (bloc) => bloc.add(ChangeShowJoined(showJoined: true)),
      expect: () => [
        StudyGroupState().copyWith(
          showJoined: true,
          endOfListReached: false,
          page: 0,
        ),
        StudyGroupState().copyWith(
          showJoined: true,
          endOfListReached: false,
          page: 0,
          isLoading: true,
        ),
        StudyGroupState().copyWith(
          showJoined: true,
          endOfListReached: false,
          page: 0,
          groups: groupList,
          isLoading: false,
        ),
      ],
      verify: (_) {
        verify(() => repository.fetchJoinedStudyGroups()).called(1);
      },
    );

    blocTest<StudyGroupBloc, StudyGroupState>(
      'NextPage increments page and fetches next page of groups',
      build: () {
        when(() => repository.fetchStudyGroups(page: 1))
            .thenAnswer((_) async => groupList);
        return StudyGroupBloc(repository);
      },
      seed: () => StudyGroupState().copyWith(page: 0),
      act: (bloc) => bloc.add(NextPage()),
      expect: () => [
        StudyGroupState().copyWith(page: 1),
        StudyGroupState().copyWith(page: 1, isLoading: true),
        StudyGroupState()
            .copyWith(page: 1, groups: groupList, isLoading: false),
      ],
      verify: (_) {
        verify(() => repository.fetchStudyGroups(page: 1)).called(1);
      },
    );

    blocTest<StudyGroupBloc, StudyGroupState>(
      'SelectGroup by ID fetches group and leaderboards',
      build: () {
        when(() => repository.fetchStudyGroup(studyGroup.id))
            .thenAnswer((_) async => studyGroup);
        when(() => repository.fetchGroupMemberDailyLeaderboard(studyGroup.id))
            .thenAnswer((_) async => []);
        when(() => repository.fetchGroupMemberTotalLeaderboard(studyGroup.id))
            .thenAnswer((_) async => []);
        when(() => repository.fetchGroupMemberGoalLeaderboard(studyGroup.id))
            .thenAnswer((_) async => goalLeaderboard);
        return StudyGroupBloc(repository);
      },
      act: (bloc) => bloc.add(SelectGroup(groupId: studyGroup.id)),
      expect: () => [
        StudyGroupState().copyWith(selectedGroup: studyGroup),
        StudyGroupState().copyWith(selectedGroup: studyGroup, isLoading: true),
        StudyGroupState().copyWith(
          selectedGroup: studyGroup,
          isLoading: false,
          dailyLeaderboard: [],
          totalLeaderboard: [],
          goalLeaderboard: goalLeaderboard,
        ),
      ],
      verify: (_) {
        verify(() => repository.fetchStudyGroup(studyGroup.id)).called(1);
        verify(() => repository.fetchGroupMemberDailyLeaderboard(studyGroup.id))
            .called(1);
        verify(() => repository.fetchGroupMemberTotalLeaderboard(studyGroup.id))
            .called(1);
        verify(() => repository.fetchGroupMemberGoalLeaderboard(studyGroup.id))
            .called(1);
      },
    );

    blocTest<StudyGroupBloc, StudyGroupState>(
      'RefreshSelectedGroup fetches selected group and leaderboards',
      build: () {
        when(() => repository.fetchStudyGroup(studyGroup.id))
            .thenAnswer((_) async => studyGroup); // simulate updated group
        when(() => repository.fetchGroupMemberDailyLeaderboard(studyGroup.id))
            .thenAnswer((_) async => []);
        when(() => repository.fetchGroupMemberTotalLeaderboard(studyGroup.id))
            .thenAnswer((_) async => []);
        when(() => repository.fetchGroupMemberGoalLeaderboard(studyGroup.id))
            .thenAnswer((_) async => goalLeaderboard);
        return StudyGroupBloc(repository);
      },
      seed: () => StudyGroupState().copyWith(selectedGroup: studyGroup),
      act: (bloc) => bloc.add(RefreshSelectedGroup()),
      verify: (_) {
        verify(() => repository.fetchStudyGroup(studyGroup.id)).called(1);
        verify(() => repository.fetchGroupMemberDailyLeaderboard(studyGroup.id))
            .called(1);
        verify(() => repository.fetchGroupMemberTotalLeaderboard(studyGroup.id))
            .called(1);
        verify(() => repository.fetchGroupMemberGoalLeaderboard(studyGroup.id))
            .called(1);
      },
    );

    blocTest<StudyGroupBloc, StudyGroupState>(
      'DeleteGroupGoal deletes goal and refreshes group & leaderboard',
      build: () {
        when(() => repository.deleteGroupGoal(studyGroup.id))
            .thenAnswer((_) async {});
        when(() => repository.fetchStudyGroup(studyGroup.id))
            .thenAnswer((_) async => studyGroup2);
        when(() => repository.fetchGroupMemberDailyLeaderboard(studyGroup.id))
            .thenAnswer((_) async => []);
        when(() => repository.fetchGroupMemberTotalLeaderboard(studyGroup.id))
            .thenAnswer((_) async => []);
        when(() => repository.fetchGroupMemberGoalLeaderboard(studyGroup.id))
            .thenAnswer((_) async => goalLeaderboard);
        return StudyGroupBloc(repository);
      },
      seed: () => StudyGroupState().copyWith(selectedGroup: studyGroup),
      act: (bloc) => bloc.add(DeleteGroupGoal()),
      verify: (_) {
        verify(() => repository.deleteGroupGoal(studyGroup.id)).called(1);
        verify(() => repository.fetchStudyGroup(studyGroup.id)).called(1);
        verify(() => repository.fetchGroupMemberDailyLeaderboard(studyGroup.id))
            .called(1);
        verify(() => repository.fetchGroupMemberTotalLeaderboard(studyGroup.id))
            .called(1);
        verify(() => repository.fetchGroupMemberGoalLeaderboard(studyGroup.id))
            .called(1);
      },
    );

    blocTest<StudyGroupBloc, StudyGroupState>(
      'ShareGroup calls repository.shareStudyGroup',
      build: () {
        when(() => repository.shareStudyGroup(studyGroup))
            .thenAnswer((_) async {});
        return StudyGroupBloc(repository);
      },
      seed: () => StudyGroupState().copyWith(selectedGroup: studyGroup),
      act: (bloc) => bloc.add(ShareGroup()),
      verify: (_) {
        verify(() => repository.shareStudyGroup(studyGroup)).called(1);
      },
    );
  });
}
