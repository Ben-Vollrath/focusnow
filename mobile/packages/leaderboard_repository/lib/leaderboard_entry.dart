import 'package:equatable/equatable.dart';

class LeaderboardEntry extends Equatable {
  final String userId;
  final String name;
  final int totalStudyTime;
  final int totalStudySessions;
  final int rank;

  const LeaderboardEntry({
    required this.userId,
    required this.name,
    required this.totalStudyTime,
    required this.totalStudySessions,
    required this.rank,
  });

  @override
  List<Object?> get props => [
    userId,
    name,
    totalStudyTime,
    totalStudySessions,
    rank,
  ];

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      userId: map['user_id'],
      name: map['name'],
      totalStudyTime: map['total_study_time'] ?? 0,
      totalStudySessions: map['total_study_sessions'] ?? 0,
      rank: map['rank'],
    );
  }
}
