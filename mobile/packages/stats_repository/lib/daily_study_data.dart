import 'package:equatable/equatable.dart';

class DailyStudyData extends Equatable {
  final String studyDate;
  final int totalStudyTime;
  final int totalStudySessions;
  final int streakDay;

  const DailyStudyData({
    required this.studyDate,
    required this.totalStudyTime,
    required this.totalStudySessions,
    required this.streakDay,
  });

  @override
  List<Object?> get props => [
    studyDate,
    totalStudyTime,
    totalStudySessions,
    streakDay,
  ];

  factory DailyStudyData.fromJson(Map<String, dynamic> json) {
    return DailyStudyData(
      studyDate: json['study_date'] as String,
      totalStudyTime: json['total_study_time'] as int,
      totalStudySessions: json['total_study_sessions'] as int,
      streakDay: json['streak_day'] as int,
    );
  }
}
