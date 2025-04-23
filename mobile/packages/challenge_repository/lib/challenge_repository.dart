import 'package:analytics_repository/analytics_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:challenge_repository/challenge.dart';
import 'package:challenge_repository/challenge_progress.dart';

class ChallengeWithProgress {
  final Challenge challenge;
  final ChallengeProgress? progress;

  ChallengeWithProgress({required this.challenge, this.progress});
}

class ChallengeRepository {
  final SupabaseClient supabaseClient;
  final AnalyticsRepository _analyticsRepository;

  ChallengeRepository({
    SupabaseClient? supabaseClient,
    AnalyticsRepository? analyticsRepository,
  }) : supabaseClient = supabaseClient ?? Supabase.instance.client,
       _analyticsRepository = analyticsRepository ?? AnalyticsRepository();

  Future<List<ChallengeWithProgress>> getChallengesWithProgress() async {
    try {
      final response = await supabaseClient
          .from('challenges')
          .select('*, challenge_progress(*)')
          .order('difficulty', ascending: true);

      final data = response as List<dynamic>;

      // Step 1: Build initial list
      final all =
          data.map((entry) {
            final challenge = Challenge.fromJson(entry);
            final progressList =
                entry['challenge_progress'] as List<dynamic>? ?? [];

            final progress =
                progressList.isNotEmpty
                    ? ChallengeProgress.fromJson(progressList.first)
                    : null;

            return ChallengeWithProgress(
              challenge: challenge,
              progress: progress,
            );
          }).toList();

      // Step 2: For each category, inject "empty" progress into lowest-difficulty challenge if needed
      final Map<ChallengeCategory, bool> hasProgressInCategory = {};

      for (final entry in all) {
        final category = entry.challenge.category;
        if (!hasProgressInCategory.containsKey(category)) {
          hasProgressInCategory[category] = entry.progress != null;
        }
      }

      final List<ChallengeWithProgress> updated = [];

      for (final entry in all) {
        final category = entry.challenge.category;

        if (!hasProgressInCategory[category]! && // No progress in this category
            updated.where((e) => e.challenge.category == category).isEmpty) {
          // This is the first (lowest difficulty) challenge in that category — inject dummy progress
          updated.add(
            ChallengeWithProgress(
              challenge: entry.challenge,
              progress: ChallengeProgress(
                challenge_id: entry.challenge.id,
                progress: 0,
                completed: false,
                last_updated: DateTime.now(),
              ),
            ),
          );
        } else {
          updated.add(entry);
        }
      }

      return updated;
    } catch (e, stackTrace) {
      _analyticsRepository.logError(e, stackTrace, "getChallengesWithProgress");
      throw Exception('Failed to fetch challenges with progress');
    }
  }
}
