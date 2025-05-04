import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:study_group_repository/goal_leaderboard_entry.dart';
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
      add(FetchJoinedGroups());
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onJoinStudyGroup(
      JoinStudyGroup event, Emitter<StudyGroupState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.joinStudyGroup(event.groupId);
      add(FetchJoinedGroups());
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onLeaveStudyGroup(
      LeaveStudyGroup event, Emitter<StudyGroupState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.leaveStudyGroup(event.groupId);
      add(FetchJoinedGroups());
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onCreateGroupGoal(
      CreateGroupGoal event, Emitter<StudyGroupState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.createStudyGroupGoal(
        name: event.name,
        description: event.description,
        studyGroupId: event.groupId,
        targetMinutes: event.targetMinutes,
        targetDate: event.targetDate,
        xpReward: event.xpReward,
      );
      add(FetchJoinedGroups());
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onFetchLeaderboards(
      FetchLeaderboards event, Emitter<StudyGroupState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final daily =
          await repository.fetchGroupMemberDailyLeaderboard(event.groupId);
      final total =
          await repository.fetchGroupMemberTotalLeaderboard(event.groupId);
      final goal =
          await repository.fetchGroupMemberGoalLeaderboard(event.groupId);
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
}
