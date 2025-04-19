part of 'stats_bloc.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadStats extends StatsEvent {
  const LoadStats();

  @override
  List<Object?> get props => [];
}

class ReloadUserStats extends StatsEvent {
  const ReloadUserStats();

  @override
  List<Object?> get props => [];
}
