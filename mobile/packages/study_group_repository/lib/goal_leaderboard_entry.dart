import 'package:equatable/equatable.dart';

class GoalLeaderboardEntry extends Equatable {
  final String userId;
  final String userName;
  final int currentMinutes;

  const GoalLeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.currentMinutes,
  });

  @override
  List<Object?> get props => [userId, currentMinutes];

  //fromjson
  factory GoalLeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return GoalLeaderboardEntry(
      userId: json['user_id'] as String,
      userName: json['username'] as String,
      currentMinutes: json['current_minutes'] as int,
    );
  }
}
