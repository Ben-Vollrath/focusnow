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

  Future<void> submitStudySession(StudySession studySession) async {
    try {
      _analyticsRepository.logEvent('study_session_completed');

      final response = await supabaseClient.functions.invoke(
        'handle-completed-study-session',
        body: studySession.toJson(),
      );

      if (response.status != 200) {
        throw Exception('Failed to submit study session');
      }
    } catch (e, stackTrace) {
      _analyticsRepository.logError(e, stackTrace, "submitStudySession");
      throw Exception('Failed to submit study session');
    }
  }
}
