part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

class StatsState extends Equatable {
  final StatsStatus status;
  final UserStats? userStats;
  final List<Map<String, dynamic>> weeklyStudyData;
  final String? errorMessage;

  const StatsState({
    this.status = StatsStatus.initial,
    this.userStats,
    this.weeklyStudyData = const [],
    this.errorMessage,
  });

  StatsState copyWith({
    StatsStatus? status,
    UserStats? userStats,
    List<Map<String, dynamic>>? weeklyStudyData,
    String? errorMessage,
  }) {
    return StatsState(
      status: status ?? this.status,
      userStats: userStats ?? this.userStats,
      weeklyStudyData: weeklyStudyData ?? this.weeklyStudyData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, userStats, weeklyStudyData, errorMessage];
}
