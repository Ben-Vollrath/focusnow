import 'package:equatable/equatable.dart';

class InputGoal extends Equatable {
  final DateTime? targetDate;
  final int targetMinutes;
  final String name;
  final String description;

  const InputGoal({
    required this.targetDate,
    required this.targetMinutes,
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [targetDate, targetMinutes, name];

  Map<String, dynamic> toJson() {
    return {
      'target_date': targetDate?.toIso8601String(),
      'target_minutes': targetMinutes,
      'name': name,
      'description': description,
    };
  }
}
