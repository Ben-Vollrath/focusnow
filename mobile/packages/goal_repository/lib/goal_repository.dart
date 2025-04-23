library goal_repository;

import 'package:analytics_repository/analytics_repository.dart';
import 'package:goal_repository/goal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalRepository {
  final SupabaseClient supabaseClient;
  final AnalyticsRepository _analyticsRepository;

  GoalRepository({
    SupabaseClient? supabaseClient,
    AnalyticsRepository? analyticsRepository,
  }) : supabaseClient = supabaseClient ?? Supabase.instance.client,
       _analyticsRepository = analyticsRepository ?? AnalyticsRepository();

  Future<Goal?> getGoal() async {
    try {
      final response =
          await supabaseClient.from('goals').select('*').maybeSingle();

      if (response == null) {
        return null;
      }

      return Goal.fromJson(response);
    } catch (e, stackTrace) {
      _analyticsRepository.logError(e, stackTrace, "getGoal");
      throw Exception('Failed to fetch goal');
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await supabaseClient.from('goals').delete().eq('id', goalId);

      _analyticsRepository.logEvent('goal_deleted');
    } catch (e, stackTrace) {
      _analyticsRepository.logError(e, stackTrace, "deleteGoal");
      throw Exception('Failed to delete goal: $e');
    }
  }

  Future<void> createGoal(InputGoal inputGoal) async {
    try {
      final response = await supabaseClient.functions.invoke(
        'create-goal',
        body: inputGoal.toJson(),
      );

      _analyticsRepository.logEvent('goal_created');
    } catch (e, stackTrace) {
      _analyticsRepository.logError(e, stackTrace, "createGoal");
      throw Exception('Failed to create goal: $e');
    }
  }
}
