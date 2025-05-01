import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leaderboard_repository/leaderboard_entry.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:meta/meta.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc({required this.leaderboardRepository})
      : super(LeaderboardState.initial()) {
    on<LeaderboardTypeChanged>(_onLeaderboardTypeChanged);
    on<LoadLeaderboard>(_onLoadLeaderboard);
  }
  final LeaderboardRepository leaderboardRepository;

  FutureOr<void> _onLeaderboardTypeChanged(
      LeaderboardTypeChanged event, Emitter<LeaderboardState> emit) {
    emit(
      state.copyWith(
        selectedType: event.type,
      ),
    );
  }

  FutureOr<void> _onLoadLeaderboard(
      LoadLeaderboard event, Emitter<LeaderboardState> emit) async {
    if (event.userId == null) {
      emit(state.copyWith(status: LeaderBoardStatus.error));
      return null;
    }

    emit(state.copyWith(status: LeaderBoardStatus.loading));
    try {
      final daily =
          await leaderboardRepository.fetchDailyLeaderboard(event.userId!);
      final total =
          await leaderboardRepository.fetchTotalLeaderboard(event.userId!);
      emit(state.copyWith(
        dailyLeaderboard: daily,
        totalLeaderboard: total,
        status: LeaderBoardStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: LeaderBoardStatus.error));
    }
  }
}
