import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/ui/app/app.dart';
import 'package:analytics_repository/analytics_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/ui/login/login_page.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockSubscriptionBloc
    extends MockBloc<SubscriptionEvent, SubscriptionState>
    implements SubscriptionBloc {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  late MockAnalyticsRepository mockAnalyticsRepository;

  setUp(() {
    mockAnalyticsRepository = MockAnalyticsRepository();
    AnalyticsRepository.setInstance(mockAnalyticsRepository);
  });

  group('AppView', () {
    late AuthenticationRepository authenticationRepository;
    late SubscriptionBloc subscriptionBloc;
    late AppBloc appBloc;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      subscriptionBloc = MockSubscriptionBloc();
      appBloc = MockAppBloc();
    });

    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      when(() => settingsBloc.state).thenReturn(SettingsState(
        isIconsCircular: true,
        iconTextColor: IconTextColors.white,
        theme: UiTheme.system,
      ));

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: settingsBloc),
                BlocProvider.value(value: subscriptionBloc),
                BlocProvider.value(value: appBloc)
              ],
              child: const NavFlowBuilder(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}

class SettingsState {}
