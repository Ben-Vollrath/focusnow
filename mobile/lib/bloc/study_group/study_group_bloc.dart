import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:study_group_repository/goal_leaderboard_entry.dart';
import 'package:study_group_repository/input_goal.dart';
import 'package:study_group_repository/leaderboard_entry.dart';
import 'package:study_group_repository/study_group.dart';
import 'package:study_group_repository/study_group_repository.dart';

part 'study_group_event.dart';
part 'study_group_state.dart';

class StudyGroupBloc extends Bloc<StudyGroupEvent, StudyGroupState> {
  final StudyGroupRepository repository;

  StudyGroupBloc(this.repository) : super(StudyGroupState()) {
    on<FetchStudyGroups>(_onFetchStudyGroups);
    on<CreateStudyGroup>(_onCreateStudyGroup);
    on<JoinStudyGroup>(_onJoinStudyGroup);
    on<LeaveStudyGroup>(_onLeaveStudyGroup);
    on<CreateGroupGoal>(_onCreateGroupGoal);
    on<FetchLeaderboards>(_onFetchLeaderboards);
    on<ChangeGroupSortBy>(_onChangeGroupSortBy);
    on<ChangeGroupSortOrder>(_onChangeGroupSortOrder);
    on<ChangeShowJoined>(_onChangeShowJoined);
    on<NextPage>(_onNextPage);
    on<SelectGroup>(_onSelectGroup);
    on<RefreshSelectedGroup>(_onRefreshSelectedGroup);
    on<DeleteGroupGoal>(_onDeleteGroupGoal);
    on<ShareGroup>(_onShareGroup);
  }

  Future<void> _onFetchStudyGroups(
      FetchStudyGroups event, Emitter<StudyGroupState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      var groups = <StudyGroup>[];
      if (state.showJoined) {
        groups = await repository.fetchJoinedStudyGroups(
          page: state.page,
          sortBy: state.sortBy,
          ascending: state.ascending,
        );
      } else {
        groups = await repository.fetchStudyGroups(
          page: state.page,
          sortBy: state.sortBy,
          ascending: state.ascending,
        );
      }

      emit(state.copyWith(
          groups: event.isNextPage
              ? [
                  ...state.groups,
                  ...groups,
                ]
              : groups,
          isLoading: false,
          endOfListReached: groups.isEmpty));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onCreateStudyGroup(
      CreateStudyGroup event, Emitter<StudyGroupState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.createStudyGroup(
        name: event.name,
        description: event.description,
        isPublic: event.isPublic,
      );
      add(FetchStudyGroups());
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onJoinStudyGroup(
      JoinStudyGroup event, Emitter<StudyGroupState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.joinStudyGroup(state.selectedGroup!.id);
      add(RefreshSelectedGroup());
      add(FetchStudyGroups());
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onLeaveStudyGroup(
      LeaveStudyGroup event, Emitter<StudyGroupState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.leaveStudyGroup(state.selectedGroup!.id);
      add(RefreshSelectedGroup());
      add(FetchStudyGroups());
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onCreateGroupGoal(
      CreateGroupGoal event, Emitter<StudyGroupState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.createStudyGroupGoal(
        goal: event.inputGoal,
        studyGroupId: state.selectedGroup!.id,
      );
      add(FetchStudyGroups());
      add(RefreshSelectedGroup());
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onFetchLeaderboards(
      FetchLeaderboards event, Emitter<StudyGroupState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final daily = await repository
          .fetchGroupMemberDailyLeaderboard(state.selectedGroup!.id);
      final total = await repository
          .fetchGroupMemberTotalLeaderboard(state.selectedGroup!.id);
      final goal = await repository
          .fetchGroupMemberGoalLeaderboard(state.selectedGroup!.id);
      emit(state.copyWith(
        dailyLeaderboard: daily,
        totalLeaderboard: total,
        goalLeaderboard: goal,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  FutureOr<void> _onChangeGroupSortBy(
      ChangeGroupSortBy event, Emitter<StudyGroupState> emit) {
    emit(
        state.copyWith(sortBy: event.sortBy, endOfListReached: false, page: 0));
    add(FetchStudyGroups());
  }

  FutureOr<void> _onChangeGroupSortOrder(
      ChangeGroupSortOrder event, Emitter<StudyGroupState> emit) {
    emit(state.copyWith(
        ascending: event.ascending, endOfListReached: false, page: 0));
    add(FetchStudyGroups());
  }

  FutureOr<void> _onChangeShowJoined(
      ChangeShowJoined event, Emitter<StudyGroupState> emit) {
    emit(state.copyWith(
        showJoined: event.showJoined, endOfListReached: false, page: 0));
    add(FetchStudyGroups());
  }

  FutureOr<void> _onNextPage(NextPage event, Emitter<StudyGroupState> emit) {
    if (state.isLoading || state.endOfListReached) return null;
    emit(state.copyWith(page: state.page + 1));
    add(FetchStudyGroups(isNextPage: true));
  }

  FutureOr<void> _onSelectGroup(
      SelectGroup event, Emitter<StudyGroupState> emit) async {
    var group = event.group;
    if (event.groupId != null) {
      group = await repository.fetchStudyGroup(event.groupId!);
    }
    emit(state.copyWith(selectedGroup: group));
    add(FetchLeaderboards());
    return null;
  }

  FutureOr<void> _onRefreshSelectedGroup(
      RefreshSelectedGroup event, Emitter<StudyGroupState> emit) async {
    final refreshedGroup =
        await repository.fetchStudyGroup(state.selectedGroup!.id);
    emit(state.copyWith(
      selectedGroup: refreshedGroup,
    ));
    add(FetchLeaderboards());
  }

  FutureOr<void> _onDeleteGroupGoal(
      DeleteGroupGoal event, Emitter<StudyGroupState> emit) async {
    try {
      await repository.deleteGroupGoal(state.selectedGroup!.id);
      add(FetchLeaderboards());
      add(RefreshSelectedGroup());
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  FutureOr<void> _onShareGroup(
      ShareGroup event, Emitter<StudyGroupState> emit) async {
    await repository.shareStudyGroup(state.selectedGroup!);
  }
}
