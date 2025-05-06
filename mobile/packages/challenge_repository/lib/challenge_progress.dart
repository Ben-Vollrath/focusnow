import 'package:equatable/equatable.dart';

class ChallengeProgress extends Equatable {
  final bool completed;
  final int progress;
  final DateTime last_updated;
  final String challenge_id;

  const ChallengeProgress({
    required this.completed,
    required this.progress,
    required this.last_updated,
    required this.challenge_id,
  });

  @override
  List<Object?> get props => [completed, progress, last_updated, challenge_id];

  factory ChallengeProgress.fromJson(Map<String, dynamic> json) {
    return ChallengeProgress(
      completed: json['completed'],
      progress: json['progress'],
      last_updated: DateTime.parse(json['last_updated']),
      challenge_id: json['challenge_id'],
    );
  }
}
