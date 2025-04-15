import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/bloc/subscription/subscription_bloc.dart';
import 'package:focusnow/ui/login/login.dart';
import 'package:focusnow/ui/study_timer/study_timer_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StudyTimerPage();
  }
}
