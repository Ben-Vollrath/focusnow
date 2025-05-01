import 'package:equatable/equatable.dart';

class LeaderboardEntry extends Equatable {
  final String userId;
  final String name;
  final int totalStudyTime;
  final int totalStudySessions;
  final int rank;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.userId,
    required this.name,
    required this.totalStudyTime,
    required this.totalStudySessions,
    required this.rank,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props => [
    userId,
    name,
    totalStudyTime,
    totalStudySessions,
    rank,
  ];

  factory LeaderboardEntry.fromMap(
    Map<String, dynamic> map, {
    bool isCurrentUser = false,
  }) {
    return LeaderboardEntry(
      userId: map['user_id'],
      name: map['username'],
      totalStudyTime: map['total_study_time'] ?? 0,
      totalStudySessions: map['total_study_sessions'] ?? 0,
      rank: map['rank'],
      isCurrentUser: isCurrentUser,
    );
  }
}
