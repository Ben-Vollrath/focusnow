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

class SelectGroup extends StudyGroupEvent {
  final String? groupId;
  final StudyGroup? group;

  SelectGroup({this.group, this.groupId});
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

  CreateStudyGroup(
      {required this.name, required this.description, required this.isPublic});
}

class JoinStudyGroup extends StudyGroupEvent {}

class LeaveStudyGroup extends StudyGroupEvent {}

class CreateGroupGoal extends StudyGroupEvent {
  final InputGoal inputGoal;

  CreateGroupGoal({
    required this.inputGoal,
  });
}

class ShareGroup extends StudyGroupEvent {}

class DeleteGroupGoal extends StudyGroupEvent {}

class FetchLeaderboards extends StudyGroupEvent {}

class RefreshSelectedGroup extends StudyGroupEvent {}
