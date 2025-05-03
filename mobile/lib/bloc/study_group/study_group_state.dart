part of 'study_group_bloc.dart';

class StudyGroupState extends Equatable {
  final List<StudyGroup> groups;
  final List<StudyGroup> joinedGroups;
  final List<LeaderboardEntry> dailyLeaderboard;
  final List<LeaderboardEntry> totalLeaderboard;
  final List<GoalLeaderboardEntry> goalLeaderboard;
  final bool isLoading;
  final String? error;

  StudyGroupState({
    this.groups = const [],
    this.joinedGroups = const [],
    this.dailyLeaderboard = const [],
    this.totalLeaderboard = const [],
    this.goalLeaderboard = const [],
    this.isLoading = false,
    this.error,
  });

  StudyGroupState copyWith({
    List<StudyGroup>? groups,
    List<StudyGroup>? joinedGroups,
    List<LeaderboardEntry>? dailyLeaderboard,
    List<LeaderboardEntry>? totalLeaderboard,
    List<GoalLeaderboardEntry>? goalLeaderboard,
    bool? isLoading,
    String? error,
  }) {
    return StudyGroupState(
      groups: groups ?? this.groups,
      joinedGroups: joinedGroups ?? this.joinedGroups,
      dailyLeaderboard: dailyLeaderboard ?? this.dailyLeaderboard,
      totalLeaderboard: totalLeaderboard ?? this.totalLeaderboard,
      goalLeaderboard: goalLeaderboard ?? this.goalLeaderboard,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        groups,
        joinedGroups,
        dailyLeaderboard,
        totalLeaderboard,
        goalLeaderboard,
        isLoading,
        error,
      ];
}
