part of 'challenge_bloc.dart';

abstract class ChallengeState extends Equatable {
  const ChallengeState();

  @override
  List<Object?> get props => [];
}

class ChallengeLoading extends ChallengeState {}

class ChallengeLoaded extends ChallengeState {
  final List<ChallengeWithProgress> challenges;

  const ChallengeLoaded({required this.challenges});

  @override
  List<Object?> get props => [challenges];
}

class ChallengeError extends ChallengeState {}
