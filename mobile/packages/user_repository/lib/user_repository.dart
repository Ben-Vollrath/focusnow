library user_repository;

import 'package:analytics_repository/analytics_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final SupabaseClient supabaseClient;
  final AnalyticsRepository _analyticsRepository;

  UserRepository({
    SupabaseClient? supabaseClient,
    AnalyticsRepository? analyticsRepository,
  }) : supabaseClient = supabaseClient ?? Supabase.instance.client,
       _analyticsRepository = analyticsRepository ?? AnalyticsRepository();

  Future<void> deleteAccount() async {
    try {
      _analyticsRepository.logEvent("delete_account");
      await supabaseClient.rpc("delete_account");
      await supabaseClient.auth.signOut();
    } catch (e, stackTrace) {
      _analyticsRepository.logError(e, stackTrace, "deleteAccount");
      throw Exception('Failed to delete account: $e');
    }
  }
}
