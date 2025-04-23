import 'package:analytics_repository/analytics_repository.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:focusnow/bloc/goal/goal_bloc.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/bloc/study_timer/study_timer_bloc.dart';
import 'package:focusnow/bloc/login/login_cubit.dart';
import 'package:focusnow/bloc/subscription/subscription_bloc.dart';
import 'package:focusnow/bloc/user/user_bloc.dart';
import 'package:focusnow/static/theme/theme.dart';
import 'package:focusnow/static/theme/util.dart';
import 'package:focusnow/ui/app/routes/routes.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:stats_repository/stats_repository.dart';
import 'package:study_session_repository/study_session_repository.dart';
import 'package:subscription_repository/subscription_repository.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class App extends StatelessWidget {
  const App(
      {required this.authenticationRepository,
      required this.subscriptionRepository,
      super.key,
      required this.notificationRepository});

  final AuthenticationRepository authenticationRepository;
  final SubscriptionRepository subscriptionRepository;
  final NotificationRepository notificationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
            create: (context) => authenticationRepository),
        RepositoryProvider<SubscriptionRepository>(
            create: (context) => subscriptionRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SubscriptionBloc>(
            create: (context) => SubscriptionBloc(subscriptionRepository),
          ),
          BlocProvider<AppBloc>(
            create: (context) =>
                AppBloc(authenticationRepository: authenticationRepository),
          ),
          BlocProvider(
              create: (context) =>
                  LoginCubit(context.read<AuthenticationRepository>())),
          BlocProvider(
            create: (context) => StudyTimerBloc(
                StudySessionRepository(), notificationRepository),
          ),
          BlocProvider(
            create: (context) => ChallengeBloc(
              repository: ChallengeRepository(),
            )..add(LoadChallenges()),
          ),
          BlocProvider(
            create: (_) =>
                StatsBloc(statsRepository: StatsRepository())..add(LoadStats()),
          ),
          BlocProvider(
            create: (_) =>
                GoalBloc(goalRepository: GoalRepository())..add(LoadGoal()),
          ),
          BlocProvider(
            create: (_) => UserBloc(),
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
    TextTheme textTheme =
        createTextTheme(context, "Varela Round", "Varela Round");
    MaterialTheme theme = MaterialTheme(textTheme);

    return BlocListener<AppBloc, AppState>(
      listener: (context, appState) {
        if (appState.status == AppStatus.authenticated) {
          context
              .read<SubscriptionBloc>()
              .add(LoadSubscription(userId: appState.user.id));
        }
      },
      child: MaterialApp(
          theme: theme.dark(),
          home: KeyboardDismissOnTap(
            dismissOnCapturedTaps: true,
            child: NavFlowBuilder(),
          )),
    );
  }
}
