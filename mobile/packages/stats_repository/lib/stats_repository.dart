library stat_repository;

import 'package:analytics_repository/analytics_repository.dart';
import 'package:stats_repository/user_stats.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatsRepository {
  final SupabaseClient supabaseClient;
  final AnalyticsRepository _analyticsRepository;

  StatsRepository({
    SupabaseClient? supabaseClient,
    AnalyticsRepository? analyticsRepository,
  }) : supabaseClient = supabaseClient ?? Supabase.instance.client,
       _analyticsRepository = analyticsRepository ?? AnalyticsRepository();

  /// Fetch user's level, XP, and total stats
  Future<UserStats> getUserStats() async {
    final userResponse =
        await supabaseClient
            .from('users')
            .select('level, xp, total_study_time, total_study_sessions')
            .single();

    final int level = userResponse['level'] ?? 1;

    final currentLevelResponse =
        await supabaseClient
            .from('levels')
            .select('name, icon')
            .eq('level', level)
            .single();

    final nextLevelResponse =
        await supabaseClient
            .from('levels')
            .select('xp_required')
            .eq('level', level + 1)
            .maybeSingle();

    return UserStats(
      level: level,
      xp: userResponse['xp'] ?? 0,
      xpToNext: nextLevelResponse?['xp_required'],
      levelName: currentLevelResponse['name'] as String,
      levelIcon: currentLevelResponse['icon'] as String?,
      totalStudyTime: userResponse['total_study_time'] ?? 0,
      totalStudySessions: userResponse['total_study_sessions'] ?? 0,
    );
  }

  /// Get study data for the last 7 days for a user
  Future<List<Map<String, dynamic>>> getWeeklyStudyData() async {
    final today = DateTime.now();
    final weekAgo = today.subtract(const Duration(days: 6));

    final response = await supabaseClient
        .from('study_days')
        .select('study_date, total_study_time')
        .gte('study_date', weekAgo.toIso8601String().substring(0, 10))
        .lte('study_date', today.toIso8601String().substring(0, 10))
        .order('study_date');

    return List<Map<String, dynamic>>.from(response);
  }
}
