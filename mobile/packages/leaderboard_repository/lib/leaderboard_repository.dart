library leaderboard_repository;

import 'package:analytics_repository/analytics_repository.dart';
import 'package:leaderboard_repository/leaderboard_entry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum LeaderboardType { daily, total }

extension LeaderboardTypeX on LeaderboardType {
  String get top5ViewName {
    switch (this) {
      case LeaderboardType.daily:
        return 'top_5_daily_study_leaderboard';
      case LeaderboardType.total:
        return 'top_5_total_study_leaderboard';
    }
  }

  String get viewName {
    switch (this) {
      case LeaderboardType.daily:
        return 'daily_study_leaderboard';
      case LeaderboardType.total:
        return 'total_study_leaderboard';
    }
  }
}

class LeaderboardRepository {
  final SupabaseClient supabaseClient;
  final AnalyticsRepository _analyticsRepository;

  LeaderboardRepository({
    SupabaseClient? supabaseClient,
    AnalyticsRepository? analyticsRepository,
  }) : supabaseClient = supabaseClient ?? Supabase.instance.client,
       _analyticsRepository = analyticsRepository ?? AnalyticsRepository();

  Future<List<LeaderboardEntry>> fetchLeaderboardWithUser(
    LeaderboardType type,
    String userId,
  ) async {
    final topResult = await supabaseClient
        .from(type.top5ViewName)
        .select()
        .limit(5);
    final topEntries =
        (topResult as List<dynamic>)
            .map((row) => LeaderboardEntry.fromMap(row as Map<String, dynamic>))
            .toList();

    final isUserInTop = topEntries.any((entry) => entry.userId == userId);
    if (isUserInTop) return topEntries;

    final userResult =
        await supabaseClient
            .from(type.viewName)
            .select()
            .eq('user_id', userId)
            .maybeSingle();

    if (userResult != null) {
      LeaderboardEntry userEntry = LeaderboardEntry.fromMap(
        userResult,
        isCurrentUser: true,
      );
      return [...topEntries, userEntry];
    } else {
      return topEntries;
    }
  }

  Future<List<LeaderboardEntry>> fetchDailyLeaderboard(String userId) {
    try {
      return fetchLeaderboardWithUser(LeaderboardType.daily, userId);
    } catch (e, stackTrace) {
      _analyticsRepository.logError(
        e,
        stackTrace,
        'Error fetching daily leaderboard',
      );
      rethrow;
    }
  }

  Future<List<LeaderboardEntry>> fetchTotalLeaderboard(String userId) {
    try {
      return fetchLeaderboardWithUser(LeaderboardType.total, userId);
    } catch (e, stackTrace) {
      _analyticsRepository.logError(
        e,
        stackTrace,
        'Error fetching total leaderboard',
      );
      rethrow;
    }
  }
}
