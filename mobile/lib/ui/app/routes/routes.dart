import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:focusnow/ui/login/login_page.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [
        MaterialPage(
          name: "HomePage",
          child: HomePage(),
        )
      ];
    case AppStatus.unauthenticated:
      return [
        MaterialPage(
          name: "Logi",
          child: LoginPage(),
        )
      ];
  }
}
