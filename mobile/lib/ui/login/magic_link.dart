import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:lottie/lottie.dart';

class MagicLinkView extends StatelessWidget {
  const MagicLinkView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.authenticated) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Email Sent!'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lottie animation
              Lottie.asset(
                "assets/email-lottie.json",
                height: 200,
                repeat: false,
              ),
              const SizedBox(height: 24.0),
              // Heading
              const Text(
                "🎉 Email Sent!",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              // Description
              const Text(
                "We've sent a login link to your email address.",
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              const Text(
                "📩 What’s next?",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                "1. Check your inbox for an email from us.\n"
                "2. Tap the link in the email to log in.\n"
                "3. Open it on this device for a seamless experience!",
                style: TextStyle(fontSize: 14.0, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              // Didn't get the email?
              const Text(
                "💡 Didn't get the email?",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                "- Make sure you entered the correct email address.\n"
                "- Check your spam or promotions folder.\n",
                style: TextStyle(fontSize: 14.0, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
