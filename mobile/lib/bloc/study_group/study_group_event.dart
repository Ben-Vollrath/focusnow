part of 'study_group_bloc.dart';

// Bloc Events
abstract class StudyGroupEvent {}

class FetchStudyGroups extends StudyGroupEvent {
  final int page;
  final StudyGroupSortBy sortBy;
  final bool ascending;

  FetchStudyGroups(
      {this.page = 0,
      this.sortBy = StudyGroupSortBy.createdAt,
      this.ascending = false});
}

class FetchJoinedGroups extends StudyGroupEvent {}

class CreateStudyGroup extends StudyGroupEvent {
  final String name;
  final String description;
  final bool isPublic;

  CreateStudyGroup(this.name, this.description, this.isPublic);
}

class JoinStudyGroup extends StudyGroupEvent {
  final String groupId;
  JoinStudyGroup(this.groupId);
}

class LeaveStudyGroup extends StudyGroupEvent {
  final String groupId;
  LeaveStudyGroup(this.groupId);
}

class CreateGroupGoal extends StudyGroupEvent {
  final String name;
  final String description;
  final String groupId;
  final int targetMinutes;
  final DateTime? targetDate;
  final int xpReward;

  CreateGroupGoal({
    required this.name,
    required this.description,
    required this.groupId,
    required this.targetMinutes,
    required this.targetDate,
    required this.xpReward,
  });
}

class FetchLeaderboards extends StudyGroupEvent {
  final String groupId;
  FetchLeaderboards(this.groupId);
}
