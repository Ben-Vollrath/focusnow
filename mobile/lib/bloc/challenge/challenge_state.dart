part of 'challenge_bloc.dart';

enum Status {
  initial,
  loading,
  loaded,
  error,
}

class ChallengeState extends Equatable {
  final List<ChallengeWithProgress> challenges;
  final ChallengeCategory? selectedCategory;
  final Status status;

  const ChallengeState({
    required this.challenges,
    required this.status,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [challenges, selectedCategory, status];

  factory ChallengeState.initial() {
    return const ChallengeState(
      challenges: [],
      status: Status.initial,
    );
  }

  ChallengeState copyWith({
    List<ChallengeWithProgress>? challenges,
    ChallengeCategory? selectedCategory,
    Status? status,
  }) {
    return ChallengeState(
      challenges: challenges ?? this.challenges,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      status: status ?? this.status,
    );
  }
}
