library study_session_repository;

import 'dart:convert';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_session_repository/study_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StudySessionRepository {
  final SupabaseClient supabaseClient;
  final AnalyticsRepository _analyticsRepository;

  static const _unsentSessionsKey = 'unsent_study_sessions';

  StudySessionRepository({
    SupabaseClient? supabaseClient,
    AnalyticsRepository? analyticsRepository,
  }) : supabaseClient = supabaseClient ?? Supabase.instance.client,
       _analyticsRepository = analyticsRepository ?? AnalyticsRepository() {
    retryUnsentSessions(); // Automatically try on init
  }

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
      await _storeUnsentSession(studySession);
    }
  }

  Future<void> retryUnsentSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? unsentJsonList = prefs.getStringList(
      _unsentSessionsKey,
    );

    if (unsentJsonList == null || unsentJsonList.isEmpty) return;

    final remaining = <String>[];

    for (final jsonString in unsentJsonList) {
      try {
        final session = StudySession.fromJson(json.decode(jsonString));
        submitStudySession(session);
      } catch (e, stackTrace) {
        _analyticsRepository.logError(e, stackTrace, "retryUnsentSessions");
        remaining.add(jsonString);
      }
    }

    await prefs.setStringList(_unsentSessionsKey, remaining);
  }

  Future<void> _storeUnsentSession(StudySession session) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_unsentSessionsKey) ?? [];
    final updated = [...current, json.encode(session.toJson())];
    await prefs.setStringList(_unsentSessionsKey, updated);
  }
}
