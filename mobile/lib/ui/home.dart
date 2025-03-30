import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/bloc/subscription/subscription_bloc.dart';
import 'package:focusnow/ui/login/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You are logged in as ${context.read<AppBloc>().state.user?.email ?? "Anonymous"}',
              style: const TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AppBloc>().add(AppLogoutRequested());
              },
              child: const Text('Logout'),
            ),
            FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: const RouteSettings(name: "LoginPage"),
                        builder: (context) => LoginPage()),
                  );
                },
                child: Text('Login anonymous user'))
          ],
        ),
      ),
    );
  }
}
