library stat_repository;

import 'package:analytics_repository/analytics_repository.dart';
import 'package:stats_repository/level.dart';
import 'package:stats_repository/user_stats.dart';
import 'package:stats_repository/daily_study_data.dart';
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
    try {
      final userResponse =
          await supabaseClient
              .from('users')
              .select('level, xp, total_study_time, total_study_sessions')
              .single();

      final int level = userResponse['level'] ?? 1;

      final currentLevelResponse =
          await supabaseClient
              .from('levels')
              .select('name, icon, xp_required')
              .eq('level', level)
              .single();

      return UserStats(
        level: level,
        xp: userResponse['xp'] ?? 0,
        xpToNext: currentLevelResponse['xp_required'],
        levelName: currentLevelResponse['name'] as String,
        levelIcon: currentLevelResponse['icon'] as String,
        totalStudyTime: userResponse['total_study_time'] ?? 0,
        totalStudySessions: userResponse['total_study_sessions'] ?? 0,
      );
    } catch (e, stackTrace) {
      _analyticsRepository.logError(e, stackTrace, "getUserStats");
      throw Exception('Failed to fetch user stats: $e');
    }
  }

  /// Get study data for the last 7 days for a user
  Future<List<DailyStudyData>> getWeeklyStudyData() async {
    try {
      final today = DateTime.now();
      final weekAgo = today.subtract(const Duration(days: 6));

      final response = await supabaseClient
          .from('study_days')
          .select(
            'study_date, total_study_time, total_study_sessions, streak_day',
          )
          .gte('study_date', weekAgo.toIso8601String().substring(0, 10))
          .lte('study_date', today.toIso8601String().substring(0, 10))
          .order('study_date');

      final List<DailyStudyData> weeklyStudyData =
          (response as List)
              .map((e) => DailyStudyData.fromJson(e as Map<String, dynamic>))
              .toList();

      return weeklyStudyData;
    } catch (e, stackTrace) {
      _analyticsRepository.logError(e, stackTrace, "getWeeklyStudyData");
      throw Exception('Failed to fetch weekly study data: $e');
    }
  }

  Future<List<Level>> getLevels() async {
    try {
      final response = await supabaseClient
          .from('levels')
          .select('level, name, icon, xp_required')
          .order('level', ascending: true);

      return (response as List)
          .map((e) => Level.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      _analyticsRepository.logError(e, stackTrace, "getLevels");
      throw Exception('Failed to fetch levels: $e');
    }
  }
}
