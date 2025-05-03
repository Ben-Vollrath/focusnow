import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leaderboard_repository/leaderboard_entry.dart';
import 'package:study_group_repository/goal_leaderboard_entry.dart';
import 'package:study_group_repository/study_group.dart';
import 'package:study_group_repository/study_group_repository.dart';

part 'study_group_event.dart';
part 'study_group_state.dart';

class StudyGroupBloc extends Bloc<StudyGroupEvent, StudyGroupState> {
  final StudyGroupRepository repository;

  StudyGroupBloc(this.repository) : super(StudyGroupState()) {
    on<FetchStudyGroups>(_onFetchStudyGroups);
    on<FetchJoinedGroups>(_onFetchJoinedGroups);
    on<CreateStudyGroup>(_onCreateStudyGroup);
    on<JoinStudyGroup>(_onJoinStudyGroup);
    on<LeaveStudyGroup>(_onLeaveStudyGroup);
    on<CreateGroupGoal>(_onCreateGroupGoal);
    on<FetchLeaderboards>(_onFetchLeaderboards);
  }

  Future<void> _onFetchStudyGroups(
      FetchStudyGroups event, Emitter<StudyGroupState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final groups = await repository.fetchStudyGroups(
        page: event.page,
        sortBy: event.sortBy,
        ascending: event.ascending,
      );
      emit(state.copyWith(groups: groups, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onFetchJoinedGroups(
      FetchJoinedGroups event, Emitter<StudyGroupState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final joinedGroups = await repository.fetchJoinedStudyGroups();
      emit(state.copyWith(joinedGroups: joinedGroups, isLoading: false));
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
        dailyLeaderboard: daily as List<LeaderboardEntry>?,
        totalLeaderboard: total as List<LeaderboardEntry>?,
        goalLeaderboard: goal,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
