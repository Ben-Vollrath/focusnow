library study_session_repository;

import 'package:analytics_repository/analytics_repository.dart';
import 'package:study_session_repository/study_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StudySessionRepository {
  final SupabaseClient supabaseClient;
  final AnalyticsRepository _analyticsRepository;

  StudySessionRepository({
    SupabaseClient? supabaseClient,
    AnalyticsRepository? analyticsRepository,
  }) : supabaseClient = supabaseClient ?? Supabase.instance.client,
       _analyticsRepository = analyticsRepository ?? AnalyticsRepository();

  Future<bool> loadReviewEligibility() async {
    final response =
        await supabaseClient
            .from('users')
            .select('claimed_review_reward')
            .single();

    return !response['claimed_review_reward'];
  }

  Future<void> submitStudySession(StudySession studySession) async {
    try {
      final response = await supabaseClient.functions.invoke(
        'handle-completed-study-session',
        body: studySession.toJson(),
      );

      if (response.status != 200) {
        throw Exception('Failed to submit study session');
      }
    } catch (e) {
      throw Exception('Failed to submit study session');
    }
  }
}
