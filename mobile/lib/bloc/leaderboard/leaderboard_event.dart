part of 'leaderboard_bloc.dart';

@immutable
sealed class LeaderboardEvent {}

final class LeaderboardTypeChanged extends LeaderboardEvent {
  LeaderboardTypeChanged(this.type);

  final LeaderboardType type;
}

final class LoadLeaderboard extends LeaderboardEvent {
  LoadLeaderboard({required this.userId});

  final String? userId;
}
