library analytics_repository;

import 'dart:isolate';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnalyticsRepository {
  // Singleton instance
  static AnalyticsRepository _instance = AnalyticsRepository._internal();

  // Final fields directly initialized in the private constructor
  final FirebaseAnalytics _firebaseAnalytics;
  final FirebaseCrashlytics _firebaseCrashlytics;

  // Factory constructor always returns the singleton instance
  factory AnalyticsRepository() {
    return _instance;
  }

  // Allows overriding the instance for testing
  @visibleForTesting
  static void setInstance(AnalyticsRepository instance) {
    _instance = instance;
  }

  // Private internal constructor
  AnalyticsRepository._internal()
      : _firebaseAnalytics = FirebaseAnalytics.instance,
        _firebaseCrashlytics = FirebaseCrashlytics.instance;

  void configureAnalytics() {
    if (kDebugMode) {
      return;
    }

    _firebaseAnalytics.setAnalyticsCollectionEnabled(true);
    FlutterError.onError = _firebaseCrashlytics.recordFlutterFatalError;

    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await _firebaseCrashlytics.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
        fatal: true,
        printDetails: true,
      );
    }).sendPort);
  }

  void logScreen(String screenName) {
    if (kDebugMode) {
      return;
    }

    _firebaseAnalytics.logScreenView(screenName: screenName);
  }

  void logEvent(String name) {
    if (kDebugMode) {
      return;
    }

    _firebaseAnalytics.logEvent(name: name);
  }

  void logError(dynamic exception, StackTrace stackTrace, String reason) {
    if (kDebugMode) {
      return;
    }

    _firebaseCrashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: true,
      printDetails: true,
    );
  }
}
