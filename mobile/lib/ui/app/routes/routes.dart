import 'package:focusnow/ui/home.dart';
import 'package:focusnow/ui/login/login_page.dart';
import 'package:focusnow/ui/paywall/paywall_page.dart'; // Add Paywall Page Import
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/bloc/subscription/subscription_bloc.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
  BuildContext context,
) {
  switch (state) {
    case AppStatus.authenticated:
      final subscriptionState = context.read<SubscriptionBloc>().state;
      if (subscriptionState is SubscriptionLoaded &&
          subscriptionState.subscription.isActive) {
        return [
          MaterialPage(
            name: "HomePage",
            child: HomePage(),
          ),
        ];
      } else {
        return [
          MaterialPage(
            name: "PaywallPage",
            child: PaywallPage(),
          ),
        ];
      }

    case AppStatus.unauthenticated:
      return [
        MaterialPage(
          name: "LoginPage",
          child: LoginPage(),
        ),
      ];
  }
}
