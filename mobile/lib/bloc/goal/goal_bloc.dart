import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goal_repository/goal.dart';
import 'package:meta/meta.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_repository/goal_repository.dart';
part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final GoalRepository goalRepository;

  GoalBloc({required this.goalRepository}) : super(GoalState.initial()) {
    on<LoadGoal>(_onLoadGoal);
    on<CreateGoal>(_onCreateGoal);
    on<DeleteGoal>(_onDeleteGoal);
  }

  Future<void> _onLoadGoal(LoadGoal event, Emitter<GoalState> emit) async {
    emit(state.copyWith(status: GoalStatus.loading));
    try {
      final goal = await goalRepository.getGoal();
      emit(state.copyWith(status: GoalStatus.loaded, goal: goal));
    } catch (e) {
      emit(state.copyWith(status: GoalStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreateGoal(CreateGoal event, Emitter<GoalState> emit) async {
    emit(state.copyWith(status: GoalStatus.loading));
    try {
      await goalRepository.createGoal(event.inputGoal);
      add(LoadGoal());
    } catch (e) {
      emit(state.copyWith(status: GoalStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDeleteGoal(DeleteGoal event, Emitter<GoalState> emit) async {
    emit(state.copyWith(status: GoalStatus.loading));
    try {
      await goalRepository.deleteGoal(event.goalId);
      emit(GoalState(status: GoalStatus.loaded, goal: null));
    } catch (e) {
      emit(state.copyWith(status: GoalStatus.error, error: e.toString()));
    }
  }
}
