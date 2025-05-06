import 'package:app_links/app_links.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:focusnow/bloc/leaderboard/leaderboard_bloc.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/bloc/study_group/study_group_bloc.dart';
import 'package:focusnow/bloc/study_timer/study_timer_bloc.dart';
import 'package:focusnow/bloc/login/login_cubit.dart';
import 'package:focusnow/bloc/subscription/subscription_bloc.dart';
import 'package:focusnow/bloc/user/user_bloc.dart';
import 'package:focusnow/static/theme/theme.dart';
import 'package:focusnow/static/theme/util.dart';
import 'package:focusnow/ui/app/routes/routes.dart';
import 'package:focusnow/ui/study_group/study_group_detail_page.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:stats_repository/stats_repository.dart';
import 'package:study_group_repository/study_group_repository.dart';
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
            create: (_) => UserBloc(),
          ),
          BlocProvider(
            create: (_) => LeaderboardBloc(
              leaderboardRepository: LeaderboardRepository(),
            ),
          ),
          BlocProvider(
            create: (_) => StudyGroupBloc(StudyGroupRepository())
              ..add(
                FetchStudyGroups(),
              ),
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
          context
              .read<LeaderboardBloc>()
              .add(LoadLeaderboard(userId: appState.user.id));
        }
        if (appState.status == AppStatus.unauthenticated) {
          context.read<SubscriptionBloc>().add(LogOut());
        }
      },
      child: MaterialApp(
          theme: theme.dark(),
          home: KeyboardDismissOnTap(
            dismissOnCapturedTaps: true,
            child: Builder(
              builder: (BuildContext context) {
                AppLinks().uriLinkStream.listen((uri) {
                  if (uri.scheme == 'io.vollrath.focusnow' &&
                      uri.host == 'group') {
                    final studyGroupId = uri.pathSegments.isNotEmpty
                        ? uri.pathSegments[0]
                        : null;
                    if (studyGroupId != null &&
                        context.read<AppBloc>().state.status ==
                            AppStatus.authenticated) {
                      context
                          .read<StudyGroupBloc>()
                          .add(SelectGroup(groupId: studyGroupId));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings:
                              const RouteSettings(name: "StudyGroupDetail"),
                          builder: (context) => StudyGroupDetailPage(),
                        ),
                      );
                    }
                  }
                });
                return NavFlowBuilder();
              },
            ),
          )),
    );
  }
}
