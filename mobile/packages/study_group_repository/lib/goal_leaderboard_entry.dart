import 'package:equatable/equatable.dart';

class GoalLeaderboardEntry extends Equatable {
  final String userId;
  final int currentMinutes;

  const GoalLeaderboardEntry({
    required this.userId,
    required this.currentMinutes,
  });

  @override
  List<Object?> get props => [userId, currentMinutes];
}
