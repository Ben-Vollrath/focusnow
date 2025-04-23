import 'package:flow_builder/flow_builder.dart';
import 'package:focusnow/bloc/subscription/subscription_bloc.dart';
import 'package:focusnow/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/ui/paywall/paywall.dart';
import 'package:focusnow/ui/start/start.dart';

class NavFlowBuilder extends StatelessWidget {
  const NavFlowBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowBuilder<AppStatus>(
      state: context.select((AppBloc bloc) => bloc.state.status),
      onGeneratePages: (state, pages) => onGenerateAppViewPages(state, pages),
    );
  }
}

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [
        MaterialPage(
          name: "HomePage",
          child: AuthedNavFlowBuilder(),
        ),
      ];

    case AppStatus.unauthenticated:
      return [
        MaterialPage(
          name: "StartPage",
          child: StartPage(),
        ),
      ];
  }
}

class AuthedNavFlowBuilder extends StatefulWidget {
  const AuthedNavFlowBuilder({super.key});

  @override
  State<AuthedNavFlowBuilder> createState() => _AuthedNavFlowBuilderState();
}

class _AuthedNavFlowBuilderState extends State<AuthedNavFlowBuilder> {
  @override
  void initState() {
    super.initState();
    context
        .read<SubscriptionBloc>()
        .add(LoadSubscription(userId: context.read<AppBloc>().state.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return FlowBuilder<SubscriptionStatus>(
      state: context.select((SubscriptionBloc bloc) => bloc.state.status),
      onGeneratePages: (state, pages) =>
          authedOnGenerateAppViewPages(state, pages),
    );
  }
}

List<Page<dynamic>> authedOnGenerateAppViewPages(
  SubscriptionStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case SubscriptionStatus.active:
      return [
        MaterialPage(
          name: "HomePage",
          child: HomePage(),
        ),
      ];

    case SubscriptionStatus.inactive:
      return [
        MaterialPage(
          name: "PayWall",
          child: PayWall(),
        ),
      ];
  }
}
