import 'package:equatable/equatable.dart';

enum ChallengeCategory {
  total_hours,
  total_sessions,
  streak_days,
  daily_sessions,
}

extension ChallengeCategoryExtension on ChallengeCategory {
  String get display_name {
    switch (this) {
      case ChallengeCategory.total_hours:
        return 'Total Hours';
      case ChallengeCategory.total_sessions:
        return 'Total Sessions';
      case ChallengeCategory.streak_days:
        return 'Streak Days';
      case ChallengeCategory.daily_sessions:
        return 'Daily Sessions';
    }
  }
}

class Challenge extends Equatable {
  final String id;
  final String name;
  final String description;
  final String icon;
  final ChallengeCategory category;
  final int reward_xp;
  final bool is_repeatable;
  final int condition_amount;
  final int difficulty;

  Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.reward_xp,
    required this.is_repeatable,
    required this.condition_amount,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    icon,
    category,
    reward_xp,
    is_repeatable,
    condition_amount,
    difficulty,
  ];

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      category: ChallengeCategory.values.byName(json['category']),
      reward_xp: json['reward_xp'],
      is_repeatable: json['is_repeatable'],
      condition_amount: json['condition_amount'],
      difficulty: json['difficulty'],
    );
  }
}
