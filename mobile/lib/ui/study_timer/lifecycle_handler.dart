import 'package:flutter/material.dart';

class StudyLifecycleHandler extends WidgetsBindingObserver {
  final VoidCallback onResume;

  StudyLifecycleHandler({required this.onResume});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }
}
