part of 'study_group_bloc.dart';

// Bloc Events
abstract class StudyGroupEvent {}

class FetchStudyGroups extends StudyGroupEvent {
  final bool isNextPage;

  FetchStudyGroups({this.isNextPage = false});
}

class ChangeGroupSortBy extends StudyGroupEvent {
  final StudyGroupSortBy sortBy;

  ChangeGroupSortBy({required this.sortBy});
}

class ChangeShowJoined extends StudyGroupEvent {
  final bool showJoined;

  ChangeShowJoined({required this.showJoined});
}

class NextPage extends StudyGroupEvent {}

class ChangeGroupSortOrder extends StudyGroupEvent {
  final bool ascending;

  ChangeGroupSortOrder({required this.ascending});
}

class FetchJoinedGroups extends StudyGroupEvent {
  final int page;

  FetchJoinedGroups({this.page = 0});
}

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
