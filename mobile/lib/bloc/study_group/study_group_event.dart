part of 'study_group_bloc.dart';

// Bloc Events
abstract class StudyGroupEvent extends Equatable {}

class FetchStudyGroups extends StudyGroupEvent {
  final bool isNextPage;

  FetchStudyGroups({this.isNextPage = false});

  @override
  List<Object?> get props => [isNextPage];
}

class ChangeGroupSortBy extends StudyGroupEvent {
  final StudyGroupSortBy sortBy;

  ChangeGroupSortBy({required this.sortBy});

  @override
  List<Object?> get props => [sortBy];
}

class ChangeShowJoined extends StudyGroupEvent {
  final bool showJoined;

  ChangeShowJoined({required this.showJoined});

  @override
  List<Object?> get props => [showJoined];
}

class SelectGroup extends StudyGroupEvent {
  final String? groupId;
  final StudyGroup? group;

  SelectGroup({this.group, this.groupId});

  @override
  List<Object?> get props => [groupId, group];
}

class NextPage extends StudyGroupEvent {
  @override
  List<Object?> get props => [];
}

class ChangeGroupSortOrder extends StudyGroupEvent {
  final bool ascending;

  ChangeGroupSortOrder({required this.ascending});

  @override
  List<Object?> get props => [ascending];
}

class CreateStudyGroup extends StudyGroupEvent {
  final String name;
  final String description;
  final bool isPublic;

  CreateStudyGroup(
      {required this.name, required this.description, required this.isPublic});

  @override
  List<Object?> get props => [name, description, isPublic];
}

class JoinStudyGroup extends StudyGroupEvent {
  @override
  List<Object?> get props => [];
}

class LeaveStudyGroup extends StudyGroupEvent {
  @override
  List<Object?> get props => [];
}

class CreateGroupGoal extends StudyGroupEvent {
  final InputGoal inputGoal;

  CreateGroupGoal({
    required this.inputGoal,
  });
  @override
  List<Object?> get props => [inputGoal];
}

class ShareGroup extends StudyGroupEvent {
  @override
  List<Object?> get props => [];
}

class DeleteGroupGoal extends StudyGroupEvent {
  @override
  List<Object?> get props => [];
}

class FetchLeaderboards extends StudyGroupEvent {
  @override
  List<Object?> get props => [];
}

class RefreshSelectedGroup extends StudyGroupEvent {
  @override
  List<Object?> get props => [];
}
