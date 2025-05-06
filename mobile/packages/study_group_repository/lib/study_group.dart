import 'package:equatable/equatable.dart';
import 'package:study_group_repository/goal.dart';

class StudyGroup extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final bool isPublic;
  final int memberCount;
  final Goal? goal;
  final bool isJoined;
  final String ownerId;

  const StudyGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.isPublic,
    required this.memberCount,
    required this.goal,
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
      goal: json['goal'] != null ? Goal.fromJson(json['goal']) : null,
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
    goal,
    isJoined,
    ownerId,
  ];
}
