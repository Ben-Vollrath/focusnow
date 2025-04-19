part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

class StatsState extends Equatable {
  final StatsStatus status;
  final UserStats? userStats;
  final List<Level>? levels;
  final List<DailyStudyData> weeklyStudyData;
  final String? errorMessage;

  const StatsState({
    this.status = StatsStatus.initial,
    this.levels,
    this.userStats,
    this.weeklyStudyData = const [],
    this.errorMessage,
  });

  StatsState copyWith({
    StatsStatus? status,
    UserStats? userStats,
    List<Level>? levels,
    List<DailyStudyData>? weeklyStudyData,
    String? errorMessage,
  }) {
    return StatsState(
      status: status ?? this.status,
      userStats: userStats ?? this.userStats,
      levels: levels ?? this.levels,
      weeklyStudyData: weeklyStudyData ?? this.weeklyStudyData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, userStats, levels, weeklyStudyData, errorMessage];
}
