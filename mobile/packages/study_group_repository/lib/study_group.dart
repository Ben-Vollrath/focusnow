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
  final bool isJoined;
  final String ownerId;

  const StudyGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.isPublic,
    required this.memberCount,
    required this.goalMinutes,
    required this.goalDate,
    required this.isJoined,
    required this.ownerId,
  });

  factory StudyGroup.fromJson(
    Map<String, dynamic> json, {
    bool isJoined = false,
  }) {
    return StudyGroup(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      isPublic: json['ispublic'],
      memberCount: json['member_count'],
      goalMinutes: json['total_goal_minutes'],
      goalDate: DateTime.tryParse(json['goal_date'] as String? ?? ''),
      isJoined: isJoined,
      ownerId: json['owner_id'],
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
    isJoined,
    ownerId,
  ];
}
