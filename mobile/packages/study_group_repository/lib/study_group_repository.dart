library study_group_repository;

import 'package:analytics_repository/analytics_repository.dart';
import 'package:study_group_repository/study_group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum StudyGroupSortBy { createdAt, memberCount, goalMinutes }

extension StudyGroupSortByExtension on StudyGroupSortBy {
  String get name {
    switch (this) {
      case StudyGroupSortBy.createdAt:
        return 'created_at';
      case StudyGroupSortBy.memberCount:
        return 'member_count';
      case StudyGroupSortBy.goalMinutes:
        return 'total_goal_minutes';
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
    StudyGroupSortBy sortBy = StudyGroupSortBy.createdAt,
    bool ascending = false,
  }) async {
    final from = page * pageSize;
    final to = from + pageSize - 1;

    final response = await supabaseClient
        .from('study_group_stats')
        .select()
        .order(sortBy.name, ascending: ascending)
        .range(from, to);

    final data = response as List<dynamic>;
    return data.map((json) => StudyGroup.fromJson(json)).toList();
  }

  Future<List<StudyGroup>> fetchJoinedStudyGroups() async {
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

    final statsRes = await supabaseClient
        .from('study_group_stats')
        .select()
        .inFilter('id', groupIds);

    final stats = statsRes as List<dynamic>;
    return stats.map((json) => StudyGroup.fromJson(json)).toList();
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
    required String name,
    required String description,
    required String studyGroupId,
    required int targetMinutes,
    required DateTime? targetDate,
    required int xpReward,
  }) async {
    await supabaseClient.rpc(
      'create_goal_template',
      params: {
        'name': name,
        'description': description,
        'study_group_id': studyGroupId,
        'target_minutes': targetMinutes,
        'target_date': targetDate?.toIso8601String(),
        'xp_reward': xpReward,
      },
    );

    _analyticsRepository.logEvent('study_group_goal_created');
  }

  Future<void> joinStudyGroup(String studyGroupId) async {
    await supabaseClient.rpc('join_study_group');

    _analyticsRepository.logEvent('study_group_joined');
  }

  Future<void> leaveStudyGroup(String studyGroupId) async {
    await supabaseClient.rpc('leave_or_delete_study_group');

    _analyticsRepository.logEvent('study_group_left');
  }

  Future<List<Map<String, dynamic>>> fetchGroupMemberDailyLeaderboard(
    String groupId,
  ) async {
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
      item['rank'] = entry.key + 1;
      return item;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> fetchGroupMemberTotalLeaderboard(
    String groupId,
  ) async {
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
      item['rank'] = entry.key + 1;
      return item;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> fetchGroupMemberGoalLeaderboard(
    String groupId,
  ) async {
    final leaderboardRes = await supabaseClient
        .from('goal_progress_leaderboard')
        .select()
        .eq('study_group_id', groupId);

    final leaderboard = leaderboardRes as List<dynamic>;
    leaderboard.sort(
      (a, b) => (b['progress_percentage'] as num).compareTo(
        a['progress_percentage'] as num,
      ),
    );

    return leaderboard.asMap().entries.map((entry) {
      final item = Map<String, dynamic>.from(entry.value);
      item['rank'] = entry.key + 1;
      return item;
    }).toList();
  }
}
