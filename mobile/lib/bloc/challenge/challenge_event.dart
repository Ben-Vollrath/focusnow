part of 'challenge_bloc.dart';

abstract class ChallengeEvent extends Equatable {
  const ChallengeEvent();

  @override
  List<Object?> get props => [];
}

class LoadChallenges extends ChallengeEvent {}

class FilterByCategory extends ChallengeEvent {
  final ChallengeCategory? category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class ToggleShowCompleted extends ChallengeEvent {}
