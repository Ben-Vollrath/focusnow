part of 'goal_bloc.dart';

enum GoalStatus { initial, loading, loaded, error }

class GoalState extends Equatable {
  final GoalStatus status;
  final Goal? goal;
  final String? error;

  const GoalState({
    required this.status,
    this.goal,
    this.error,
  });

  factory GoalState.initial() => const GoalState(status: GoalStatus.initial);

  GoalState copyWith({
    GoalStatus? status,
    Goal? goal,
    String? error,
  }) {
    return GoalState(
      status: status ?? this.status,
      goal: goal ?? this.goal,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, goal, error];
}
