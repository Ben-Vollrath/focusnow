import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/bloc/subscription/subscription_bloc.dart';
import 'package:focusnow/ui/home.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class PayWall extends StatefulWidget {
  const PayWall({super.key});

  @override
  State<PayWall> createState() => _PayWallState();
}

class _PayWallState extends State<PayWall> {
  Future<bool> checkPurchasesConfigured() async {
    return await Purchases.isConfigured;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: FutureBuilder<bool>(
          future: checkPurchasesConfigured(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return PaywallView(
                displayCloseButton: true,
                onDismiss: () {
                  context.read<AppBloc>().add(
                        AppLogoutRequested(),
                      );
                },
              );
            }
          },
        ),
      ),
    ));
  }
}
