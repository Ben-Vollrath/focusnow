part of 'leaderboard_bloc.dart';

enum LeaderBoardStatus {
  initial,
  loading,
  loaded,
  error,
}

final class LeaderboardState extends Equatable {
  final LeaderboardType selectedType;
  final List<LeaderboardEntry> dailyLeaderboard;
  final List<LeaderboardEntry> totalLeaderboard;
  final LeaderBoardStatus status;

  const LeaderboardState({
    required this.selectedType,
    required this.dailyLeaderboard,
    required this.totalLeaderboard,
    required this.status,
  });

  factory LeaderboardState.initial() {
    return const LeaderboardState(
      selectedType: LeaderboardType.daily,
      dailyLeaderboard: [],
      totalLeaderboard: [],
      status: LeaderBoardStatus.initial,
    );
  }

  LeaderboardState copyWith({
    LeaderboardType? selectedType,
    List<LeaderboardEntry>? dailyLeaderboard,
    List<LeaderboardEntry>? totalLeaderboard,
    LeaderBoardStatus? status,
  }) {
    return LeaderboardState(
      selectedType: selectedType ?? this.selectedType,
      dailyLeaderboard: dailyLeaderboard ?? this.dailyLeaderboard,
      totalLeaderboard: totalLeaderboard ?? this.totalLeaderboard,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        selectedType,
        dailyLeaderboard,
        totalLeaderboard,
        status,
      ];
}
