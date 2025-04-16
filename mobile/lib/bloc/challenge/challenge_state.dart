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
  final bool showCompleted;

  const ChallengeState({
    required this.challenges,
    required this.status,
    required this.showCompleted,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [challenges, selectedCategory, status];

  factory ChallengeState.initial() {
    return const ChallengeState(
      challenges: [],
      status: Status.initial,
      showCompleted: true,
    );
  }

  ChallengeState copyWith({
    List<ChallengeWithProgress>? challenges,
    ChallengeCategory? selectedCategory,
    Status? status,
    bool? showCompleted,
  }) {
    return ChallengeState(
      challenges: challenges ?? this.challenges,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      status: status ?? this.status,
      showCompleted: showCompleted ?? this.showCompleted,
    );
  }
}
