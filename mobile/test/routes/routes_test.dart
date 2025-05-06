import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/ui/app/routes/routes.dart';
import 'package:focusnow/ui/home.dart';
import 'package:focusnow/ui/paywall/paywall.dart';
import 'package:focusnow/ui/start/start_page.dart';
import 'package:focusnow/bloc/subscription/subscription_bloc.dart';

void main() {
  group('onGenerateAppViewPages', () {
    test('returns [AuthedNavFlowBuilder] when authenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.authenticated, []),
        [
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<AuthedNavFlowBuilder>(),
          ),
        ],
      );
    });

    test('returns [LoginPage] when unauthenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.unauthenticated, []),
        [
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<StartPage>(),
          ),
        ],
      );
    });
  });
  group('authedOnGenerateAppViewPages', () {
    test('returns [HomePage] when authenticated', () {
      expect(
        authedOnGenerateAppViewPages(SubscriptionStatus.active, []),
        [
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<HomePage>(),
          ),
        ],
      );
    });

    test('returns [LoginPage] when unauthenticated', () {
      expect(
        authedOnGenerateAppViewPages(SubscriptionStatus.inactive, []),
        [
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<PayWall>(),
          ),
        ],
      );
    });
  });
}
