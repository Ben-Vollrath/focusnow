import 'dart:async';
import 'package:analytics_repository/analytics_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:subscription_repository/src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/subscription.dart';

class FetchSubscriptionError implements Exception {
  final String message =
      "An Error occurred while fetching the subscription, please try again later";
}

/// Emitted during the Purchasing process
enum PurchaseState { loading, success, error }

class SubscriptionRepository {
  final String _publicSdkKey;
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final AnalyticsRepository _analyticsRepository;

  final _subscriptionController = StreamController<Subscription>.broadcast();

  SubscriptionRepository(String publicSdkKey,
      {AnalyticsRepository? analyticsRepository})
      : _publicSdkKey = publicSdkKey,
        _analyticsRepository = analyticsRepository ?? AnalyticsRepository() {
    Purchases.addCustomerInfoUpdateListener((purchaserInfo) async {
      final subscription = await getUserSubscription();
      _subscriptionController.add(subscription);
    });
  }

  Stream<Subscription> get subscriptionStream => _subscriptionController.stream;

  /// Configures the Purchases Instance
  ///
  /// Is called in the [SubscriptionBloc] when subscription is loaded the first time
  Future<void> configurePurchases(String userId) async {
    if (await Purchases.isConfigured) {
      Purchases.logIn(userId);
      return;
    }

    await Purchases.configure(
        PurchasesConfiguration(_publicSdkKey)..appUserID = userId);
  }

  /// Fetches the user subscription from RevenueCat
  ///
  /// If the user has no premium subscription, their current credits will be fetched from the DB.
  Future<Subscription> getUserSubscription() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      bool userIsPremium =
          customerInfo.entitlements.all.containsKey("Subscription Access") &&
              customerInfo.entitlements.all["Subscription Access"]?.isActive ==
                  true;

      return Subscription(isActive: userIsPremium);
    } catch (e, stackTrace) {
      _analyticsRepository.logError(
          e, stackTrace, "Failed to fetch subscription");
      throw FetchSubscriptionError();
    }
  }

  void reloadSubscription() async {
    final subscription = await getUserSubscription();
    _subscriptionController.add(subscription);
  }

  Future<void> logOut() async {
    try {
      await Purchases.logOut();
    } on PlatformException catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, null, reason: "Failed to log out from Purchases");
    }
  }

  /// Dispose the StreamController when done
  void dispose() {
    _subscriptionController.close();
  }
}
