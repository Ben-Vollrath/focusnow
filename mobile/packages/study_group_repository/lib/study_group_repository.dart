library study_group_repository;

import 'package:analytics_repository/analytics_repository.dart';
import 'package:study_group_repository/goal_leaderboard_entry.dart';
import 'package:study_group_repository/input_goal.dart';
import 'package:study_group_repository/leaderboard_entry.dart';
import 'package:study_group_repository/study_group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum StudyGroupSortBy { memberCount, goalMinutes, goalDate, createdAt }

extension StudyGroupSortByExtension on StudyGroupSortBy {
  String get name {
    switch (this) {
      case StudyGroupSortBy.createdAt:
        return 'created_at';
      case StudyGroupSortBy.memberCount:
        return 'member_count';
      case StudyGroupSortBy.goalMinutes:
        return 'total_goal_minutes';
      case StudyGroupSortBy.goalDate:
        return 'goal_date';
    }
  }

  String get displayName {
    switch (this) {
      case StudyGroupSortBy.createdAt:
        return 'Created At';
      case StudyGroupSortBy.memberCount:
        return 'Member Count';
      case StudyGroupSortBy.goalMinutes:
        return 'Goal Time';
      case StudyGroupSortBy.goalDate:
        return 'Goal Date';
    }
  }
}

class StudyGroupRepository {
  final SupabaseClient supabaseClient;
  final AnalyticsRepository _analyticsRepository;

  StudyGroupRepository({
    SupabaseClient? supabaseClient,
    AnalyticsRepository? analyticsRepository,
  }) : supabaseClient = supabaseClient ?? Supabase.instance.client,
       _analyticsRepository = analyticsRepository ?? AnalyticsRepository();

  Future<List<StudyGroup>> fetchStudyGroups({
    int page = 0,
    int pageSize = 6,
    StudyGroupSortBy sortBy = StudyGroupSortBy.memberCount,
    bool ascending = false,
  }) async {
    final userId = supabaseClient.auth.currentUser?.id;
    List<String> joinedGroupIds = [];

    if (userId != null) {
      final memberRes = await supabaseClient
          .from('study_group_members')
          .select('study_group_id')
          .eq('user_id', userId);

      joinedGroupIds =
          (memberRes as List<dynamic>)
              .map((e) => e['study_group_id'] as String)
              .toList();
    }

    return _fetchStudyGroupsFromStats(
      sortBy: sortBy,
      ascending: ascending,
      page: page,
      pageSize: pageSize,
      joinedGroupIds: joinedGroupIds,
    );
  }

  Future<StudyGroup?> fetchStudyGroup(String groupId) async {
    final response =
        await supabaseClient
            .from('study_group_stats')
            .select()
            .eq('id', groupId)
            .single();

    if (response == null) return null;

    final userId = supabaseClient.auth.currentUser?.id;
    bool isJoined = false;

    if (userId != null) {
      final memberRes = await supabaseClient
          .from('study_group_members')
          .select('study_group_id')
          .eq('user_id', userId)
          .eq('study_group_id', groupId);

      isJoined = (memberRes as List<dynamic>).isNotEmpty;
    }

    return StudyGroup.fromJson(response, isJoined: isJoined);
  }

  Future<List<StudyGroup>> fetchJoinedStudyGroups({
    int page = 0,
    int pageSize = 6,
    StudyGroupSortBy sortBy = StudyGroupSortBy.memberCount,
    bool ascending = false,
  }) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final memberRes = await supabaseClient
        .from('study_group_members')
        .select('study_group_id')
        .eq('user_id', userId);

    final groupIds =
        (memberRes as List<dynamic>)
            .map((e) => e['study_group_id'] as String)
            .toList();

    if (groupIds.isEmpty) return [];

    return _fetchStudyGroupsFromStats(
      sortBy: sortBy,
      ascending: ascending,
      filterIds: groupIds,
      joinedGroupIds: groupIds,
    );
  }

  Future<List<StudyGroup>> _fetchStudyGroupsFromStats({
    required StudyGroupSortBy sortBy,
    required bool ascending,
    int page = 0,
    int pageSize = 6,
    List<String>? filterIds,
    List<String> joinedGroupIds = const [],
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;
    var query;

    if (filterIds != null && filterIds.isNotEmpty) {
      query = supabaseClient
          .from('study_group_stats')
          .select()
          .inFilter('id', filterIds)
          .order(sortBy.name, ascending: ascending)
          .range(from, to);
    } else {
      query = supabaseClient
          .from('study_group_stats')
          .select()
          .order(sortBy.name, ascending: ascending)
          .range(from, to);
    }

    final response = await query;
    final data = response as List<dynamic>;

    return data.map((json) {
      final id = json['id'];
      final isJoined = joinedGroupIds.contains(id);
      return StudyGroup.fromJson(json, isJoined: isJoined);
    }).toList();
  }

  Future<void> createStudyGroup({
    required String name,
    required String description,
    required bool isPublic,
  }) async {
    await supabaseClient.rpc(
      'create_study_group',
      params: {
        'group_name': name,
        'group_description': description,
        'is_public': isPublic,
      },
    );

    _analyticsRepository.logEvent('study_group_created');
  }

  Future<void> createStudyGroupGoal({
    required InputGoal goal,
    required String studyGroupId,
  }) async {
    final params = goal.toJson()..addAll({'study_group_id': studyGroupId});
    await supabaseClient.rpc('create_goal_template', params: params);

    _analyticsRepository.logEvent('study_group_goal_created');
  }

  Future<void> deleteGroupGoal(String goalId) async {
    await supabaseClient.rpc(
      'delete_goal_template',
      params: {'goal_id': goalId},
    );

    _analyticsRepository.logEvent('study_group_goal_deleted');
  }

  Future<void> joinStudyGroup(String studyGroupId) async {
    await supabaseClient.rpc(
      'join_study_group',
      params: {'p_study_group_id': studyGroupId},
    );

    _analyticsRepository.logEvent('study_group_joined');
  }

  Future<void> leaveStudyGroup(String studyGroupId) async {
    await supabaseClient.rpc(
      'leave_or_delete_study_group',
      params: {'p_study_group_id': studyGroupId},
    );

    _analyticsRepository.logEvent('study_group_left');
  }

  Future<List<StudyGroupLeaderboardEntry>> fetchGroupMemberDailyLeaderboard(
    String groupId,
  ) async {
    final currentUserId = supabaseClient.auth.currentUser?.id;
    if (currentUserId == null) throw Exception('User not authenticated');

    final userRes = await supabaseClient
        .from('study_group_members')
        .select('user_id')
        .eq('study_group_id', groupId);

    final userIds =
        (userRes as List).map((e) => e['user_id'] as String).toList();
    if (userIds.isEmpty) return [];

    final leaderboardRes = await supabaseClient
        .from('daily_study_leaderboard')
        .select()
        .inFilter('user_id', userIds);

    final leaderboard = leaderboardRes as List<dynamic>;

    leaderboard.sort(
      (a, b) => (b['total_study_time'] as int).compareTo(
        a['total_study_time'] as int,
      ),
    );

    return leaderboard.asMap().entries.map((entry) {
      final item = Map<String, dynamic>.from(entry.value);
      final rank = entry.key + 1;
      return StudyGroupLeaderboardEntry.fromMap({
        ...item,
        'rank': rank,
      }, isCurrentUser: item['user_id'] == currentUserId);
    }).toList();
  }

  Future<List<StudyGroupLeaderboardEntry>> fetchGroupMemberTotalLeaderboard(
    String groupId,
  ) async {
    final currentUserId = supabaseClient.auth.currentUser?.id;
    if (currentUserId == null) throw Exception('User not authenticated');

    final userRes = await supabaseClient
        .from('study_group_members')
        .select('user_id')
        .eq('study_group_id', groupId);

    final userIds =
        (userRes as List).map((e) => e['user_id'] as String).toList();
    if (userIds.isEmpty) return [];

    final leaderboardRes = await supabaseClient
        .from('total_study_leaderboard')
        .select()
        .inFilter('user_id', userIds);

    final leaderboard = leaderboardRes as List<dynamic>;

    leaderboard.sort(
      (a, b) => (b['total_study_time'] as int).compareTo(
        a['total_study_time'] as int,
      ),
    );

    return leaderboard.asMap().entries.map((entry) {
      final item = Map<String, dynamic>.from(entry.value);
      final rank = entry.key + 1;
      return StudyGroupLeaderboardEntry.fromMap({
        ...item,
        'rank': rank,
      }, isCurrentUser: item['user_id'] == currentUserId);
    }).toList();
  }

  Future<List<GoalLeaderboardEntry>> fetchGroupMemberGoalLeaderboard(
    String groupId,
  ) async {
    final leaderboardRes = await supabaseClient
        .from('goal_progress_leaderboard')
        .select()
        .eq('study_group_id', groupId);

    final leaderboard = leaderboardRes as List<dynamic>;

    leaderboard.sort(
      (a, b) =>
          (b['current_minutes'] as int).compareTo(a['current_minutes'] as int),
    );

    return leaderboard.map((entry) {
      final item = Map<String, dynamic>.from(entry);
      return GoalLeaderboardEntry.fromJson(item);
    }).toList();
  }
}
