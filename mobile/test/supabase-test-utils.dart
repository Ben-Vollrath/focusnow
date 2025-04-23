import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

Future<void> initSupabaseForTests() async {
  SharedPreferences.setMockInitialValues({});

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'].toString(),
    anonKey: dotenv.env['SUPABASE_ANON_KEY'].toString(),
  );
}

Future<AuthResponse> createAnonymousTestUser() async {
  await initSupabaseForTests();
  final supabase = Supabase.instance.client;

  final response = await supabase.auth.signInAnonymously();

  return response;
}
