import 'package:analytics_repository/analytics_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/ui/login/login_form.dart';
import 'package:focusnow/ui/login/login_page.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  late MockAnalyticsRepository mockAnalyticsRepository;

  setUp(() {
    mockAnalyticsRepository = MockAnalyticsRepository();
    AnalyticsRepository.setInstance(mockAnalyticsRepository);
  });

  group('LoginPage', () {
    test('has a page', () {
      expect(LoginPage.page(), isA<MaterialPage<void>>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => MockAuthenticationRepository(),
          child: const MaterialApp(home: LoginPage()),
        ),
      );
      expect(find.byType(LoginForm), findsOneWidget);
      verify(() => mockAnalyticsRepository.logScreen("Login Page")).called(1);
    });
  });
}
