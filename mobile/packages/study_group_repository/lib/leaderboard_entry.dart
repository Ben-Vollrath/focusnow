import 'package:equatable/equatable.dart';

class StudyGroupLeaderboardEntry extends Equatable {
  final String userId;
  final String userName;
  final int totalStudyTime;
  final int totalStudySessions;
  final int rank;
  final bool isCurrentUser;

  const StudyGroupLeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.totalStudyTime,
    required this.totalStudySessions,
    required this.rank,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props => [
    userId,
    userName,
    totalStudyTime,
    totalStudySessions,
    rank,
  ];

  factory StudyGroupLeaderboardEntry.fromMap(
    Map<String, dynamic> map, {
    bool isCurrentUser = false,
  }) {
    return StudyGroupLeaderboardEntry(
      userId: map['user_id'],
      userName: map['username'],
      totalStudyTime: map['total_study_time'] ?? 0,
      totalStudySessions: map['total_study_sessions'] ?? 0,
      rank: map['rank'],
      isCurrentUser: isCurrentUser,
    );
  }
}
