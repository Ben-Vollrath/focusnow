library review_repository;

import 'package:analytics_repository/analytics_repository.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewRepository {
  final SupabaseClient supabaseClient;
  final AnalyticsRepository _analyticsRepository;
  final InAppReview inAppReview = InAppReview.instance;

  ReviewRepository(
      {SupabaseClient? supabaseClient,
      AnalyticsRepository? analyticsRepository})
      : supabaseClient = supabaseClient ?? Supabase.instance.client,
        _analyticsRepository = analyticsRepository ?? AnalyticsRepository();

  Future<bool> loadReviewEligibility() async {
    final response = await supabaseClient
        .from('users')
        .select('claimed_review_reward')
        .single();

    return !response['claimed_review_reward'];
  }

  Future<void> pushToStoreReviewPage() async {
    final Uri uri = Uri.parse(
        "https://play.google.com/store/apps/details?id=io.vollrath.focusnow");
    await launchUrl(uri);
    claimReviewReward();
  }

  Future<void> claimReviewReward() async {
    await supabaseClient.functions.invoke("claim-review-reward");
  }

  Future<void> showInAppReview() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }
}
