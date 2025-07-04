import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class PayWall extends StatefulWidget {
  const PayWall({super.key});

  @override
  State<PayWall> createState() => _PayWallState();
}

class _PayWallState extends State<PayWall> {
  bool boughtItem = false;

  Future<bool> checkPurchasesConfigured() async {
    return await Purchases.isConfigured;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: Stack(children: [
        Center(
          child: FutureBuilder<bool>(
            future: checkPurchasesConfigured(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return PaywallView(
                  displayCloseButton: true,
                  onPurchaseCompleted: (customerInfo, storeTrans) {
                    boughtItem = true;
                  },
                  onRestoreCompleted: (customerInfo) {
                    boughtItem = true;
                  },
                  onDismiss: () {
                    if (!boughtItem) {
                      context.read<AppBloc>().add(
                            AppLogoutRequested(),
                          );
                    }
                  },
                );
              }
            },
          ),
        ),
        Positioned(
          top: 24,
          right: 16,
          child: IconButton(
            iconSize: 30,
            icon: const Icon(Icons.close),
            onPressed: () {
              context.read<AppBloc>().add(AppLogoutRequested());
            },
          ),
        ),
      ]),
    ));
  }
}
