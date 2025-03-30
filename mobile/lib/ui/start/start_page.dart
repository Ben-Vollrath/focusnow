import 'package:focusnow/bloc/login/login_cubit.dart';
import 'package:focusnow/ui/login/login.dart';
import 'package:analytics_repository/analytics_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  static Page<void> page() => MaterialPage<void>(child: StartPage());

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    AnalyticsRepository().logScreen("Start Page");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Background image with overlay
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Image.asset(
                  'assets/login_background.png',
                  fit: BoxFit.cover,
                ),
              ),
              FilledButton(
                  onPressed: () {
                    context.read<LoginCubit>().signIgnAnonymously();
                  },
                  child: Text('Get Started')),
              FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: const RouteSettings(name: "LoginPage"),
                          builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
