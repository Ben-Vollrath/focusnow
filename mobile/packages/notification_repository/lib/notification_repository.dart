library notification_repository;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:analytics_repository/analytics_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepository {
  final SupabaseClient supabaseClient;
  final AnalyticsRepository _analyticsRepository;
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationRepository({
    SupabaseClient? supabaseClient,
    AnalyticsRepository? analyticsRepository,
    FlutterLocalNotificationsPlugin? notificationsPlugin,
  }) : supabaseClient = supabaseClient ?? Supabase.instance.client,
       _analyticsRepository = analyticsRepository ?? AnalyticsRepository(),
       _notificationsPlugin =
           notificationsPlugin ?? FlutterLocalNotificationsPlugin();

  /// Initializes local notifications
  Future<void> initialize() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/ic_notification_icon');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  /// Requests notification permission (important for Android 13+)
  Future<void> requestPermission() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// Show a notification when the study session is complete
  Future<void> showStudySessionCompletedNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'study_channel_id',
      'Study Notifications',
      channelDescription: 'Notifications related to study sessions',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      'Study Session Complete 🎉',
      'Great job! You’ve completed your session.',
      notificationDetails,
    );

    _analyticsRepository.logEvent('study_session_complete_notification_shown');
  }

  Future<void> showStudySessionBreakNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'study_channel_id',
      'Study Notifications',
      channelDescription: 'Notifications related to study sessions',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      1,
      'Time for a Break! ⏰',
      'Your work time is over. Take a break!',
      notificationDetails,
    );

    _analyticsRepository.logEvent('study_session_complete_notification_shown');
  }
}
