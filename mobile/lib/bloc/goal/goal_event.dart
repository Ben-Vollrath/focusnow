part of 'goal_bloc.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object?> get props => [];
}

class LoadGoal extends GoalEvent {}

class CreateGoal extends GoalEvent {
  final InputGoal inputGoal;

  const CreateGoal(this.inputGoal);

  @override
  List<Object?> get props => [inputGoal];
}

class DeleteGoal extends GoalEvent {
  final String goalId;

  const DeleteGoal(this.goalId);

  @override
  List<Object?> get props => [goalId];
}
