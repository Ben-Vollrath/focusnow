import 'dart:isolate';

import 'package:focusnow/ui/app/app.dart';
import 'package:focusnow/ui/app/bloc_observer.dart';
import 'package:focusnow/firebase_options.dart';
import 'package:focusnow/ui/splashscreen/splashscreen.dart';
import 'package:analytics_repository/analytics_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subscription_repository/subscription_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Display splash screen while initializing
  runApp(MaterialApp(
    home: SplashScreen(),
  ));

  // HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kReleaseMode) {
    AnalyticsRepository().configureAnalytics();
  }
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'].toString(),
    anonKey: dotenv.env['SUPABASE_ANON_KEY'].toString(),
  );

  // Initialize Google Sign-In
  final webClientId = dotenv.env['WEB_CLIENT_ID'];
  final googleSignIn = GoogleSignIn(
    serverClientId: webClientId,
  );

  // Initialize Authentication Repository
  final authenticationRepository = AuthenticationRepository(
    googleSignIn: googleSignIn,
  );
  await authenticationRepository.user.first;

  //final subscriptionRepository = SubscriptionRepository(dotenv.env['REVENUECAT_PROJECT_GOOGLE_API_KEY']!);

  // After initialization, run the main app
  runApp(App(
    authenticationRepository: authenticationRepository,
  ));
}
