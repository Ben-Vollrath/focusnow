part of 'study_group_bloc.dart';

class StudyGroupState extends Equatable {
  final List<StudyGroup> groups;
  final List<StudyGroupLeaderboardEntry> dailyLeaderboard;
  final List<StudyGroupLeaderboardEntry> totalLeaderboard;
  final List<GoalLeaderboardEntry> goalLeaderboard;
  final bool isLoading;
  final String? error;
  final StudyGroupSortBy sortBy;
  final bool ascending;
  final bool showJoined;
  final int page;
  final bool endOfListReached;

  StudyGroupState({
    this.groups = const [],
    this.dailyLeaderboard = const [],
    this.totalLeaderboard = const [],
    this.goalLeaderboard = const [],
    this.isLoading = false,
    this.error,
    this.sortBy = StudyGroupSortBy.memberCount,
    this.ascending = false,
    this.showJoined = false,
    this.page = 0,
    this.endOfListReached = false,
  });

  StudyGroupState copyWith({
    List<StudyGroup>? groups,
    List<StudyGroupLeaderboardEntry>? dailyLeaderboard,
    List<StudyGroupLeaderboardEntry>? totalLeaderboard,
    List<GoalLeaderboardEntry>? goalLeaderboard,
    bool? isLoading,
    String? error,
    StudyGroupSortBy? sortBy,
    bool? ascending,
    bool? showJoined,
    int? page,
    bool? endOfListReached,
  }) {
    return StudyGroupState(
      groups: groups ?? this.groups,
      dailyLeaderboard: dailyLeaderboard ?? this.dailyLeaderboard,
      totalLeaderboard: totalLeaderboard ?? this.totalLeaderboard,
      goalLeaderboard: goalLeaderboard ?? this.goalLeaderboard,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
      showJoined: showJoined ?? this.showJoined,
      page: page ?? this.page,
      endOfListReached: endOfListReached ?? this.endOfListReached,
    );
  }

  @override
  List<Object?> get props => [
        groups,
        dailyLeaderboard,
        totalLeaderboard,
        goalLeaderboard,
        isLoading,
        error,
        sortBy,
        ascending,
        showJoined,
        page,
        endOfListReached,
      ];
}
