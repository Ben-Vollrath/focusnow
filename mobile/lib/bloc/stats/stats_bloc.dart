import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stats_repository/daily_study_data.dart';
import 'package:stats_repository/level.dart';
import 'package:stats_repository/stats_repository.dart';
import 'package:stats_repository/user_stats.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final StatsRepository statsRepository;

  StatsBloc({required this.statsRepository}) : super(const StatsState()) {
    on<LoadStats>(_onLoadStats);
    on<ReloadUserStats>(_onReloadUserStats);
  }

  Future<void> _onLoadStats(
    LoadStats event,
    Emitter<StatsState> emit,
  ) async {
    emit(state.copyWith(status: StatsStatus.loading));

    try {
      final userStats = await statsRepository.getUserStats();
      final weeklyData = await statsRepository.getWeeklyStudyData();
      final levels = await statsRepository.getLevels();

      emit(state.copyWith(
        status: StatsStatus.success,
        userStats: userStats,
        weeklyStudyData: weeklyData,
        levels: levels,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StatsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  FutureOr<void> _onReloadUserStats(
      ReloadUserStats event, Emitter<StatsState> emit) async {
    emit(state.copyWith(status: StatsStatus.loading));

    try {
      final userStats = await statsRepository.getUserStats();
      final weeklyData = await statsRepository.getWeeklyStudyData();

      emit(state.copyWith(
        status: StatsStatus.success,
        userStats: userStats,
        weeklyStudyData: weeklyData,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StatsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
