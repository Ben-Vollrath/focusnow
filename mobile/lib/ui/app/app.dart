import 'package:analytics_repository/analytics_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/static/theme/theme.dart';
import 'package:focusnow/static/theme/util.dart';
import 'package:focusnow/ui/app/routes/routes.dart';
import 'package:subscription_repository/subscription_repository.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class App extends StatelessWidget {
  const App({
    required this.authenticationRepository,
    super.key,
  });

  final AuthenticationRepository authenticationRepository;
  //final SubscriptionRepository subscriptionRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
            create: (context) => authenticationRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) =>
                AppBloc(authenticationRepository: authenticationRepository),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme =
        createTextTheme(context, "Varela Round", "Varela Round");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
        ],
        theme: theme.dark(),
        home: KeyboardDismissOnTap(
          dismissOnCapturedTaps: true,
          child: NavFlowBuilder(),
        ));
  }
}

class NavFlowBuilder extends StatelessWidget {
  const NavFlowBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowBuilder<AppStatus>(
      state: context.select((AppBloc bloc) => bloc.state.status),
      onGeneratePages: onGenerateAppViewPages,
    );
  }
}
