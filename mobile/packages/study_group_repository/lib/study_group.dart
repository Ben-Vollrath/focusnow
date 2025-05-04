import 'package:equatable/equatable.dart';

class StudyGroup extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final bool isPublic;
  final int memberCount;
  final int? goalMinutes;
  final DateTime? goalDate;

  const StudyGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.isPublic,
    required this.memberCount,
    required this.goalMinutes,
    required this.goalDate,
  });

  factory StudyGroup.fromJson(Map<String, dynamic> json) {
    return StudyGroup(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      isPublic: json['ispublic'],
      memberCount: json['member_count'],
      goalMinutes: json['total_goal_minutes'],
      goalDate: DateTime.tryParse(json['goal_date'] as String? ?? ''),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    createdAt,
    isPublic,
    memberCount,
    goalMinutes,
    goalDate,
  ];
}
