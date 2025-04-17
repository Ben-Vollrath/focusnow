import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime? targetDate;
  final int targetMinutes;
  final int currentMinutes;
  final bool completed;
  final String name;
  final int xpReward;

  Goal({
    required this.id,
    required this.createdAt,
    required this.targetDate,
    required this.targetMinutes,
    required this.currentMinutes,
    required this.completed,
    required this.name,
    required this.xpReward,
  });

  @override
  List<Object?> get props => [
    id,
    createdAt,
    targetDate,
    targetMinutes,
    currentMinutes,
    completed,
    name,
    xpReward,
  ];

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      targetDate:
          json['target_date'] != null
              ? DateTime.parse(json['target_date'])
              : null,
      targetMinutes: json['target_minutes'],
      currentMinutes: json['current_minutes'],
      completed: json['completed'],
      name: json['name'],
      xpReward: json['xp_reward'],
    );
  }
}

class InputGoal extends Equatable {
  final DateTime? targetDate;
  final int targetMinutes;
  final String name;

  InputGoal({
    required this.targetDate,
    required this.targetMinutes,
    required this.name,
  });

  @override
  List<Object?> get props => [targetDate, targetMinutes, name];

  Map<String, dynamic> toJson() {
    return {
      'target_date': targetDate?.toIso8601String(),
      'target_minutes': targetMinutes,
      'name': name,
    };
  }
}
