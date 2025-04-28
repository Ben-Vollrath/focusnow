import 'package:flutter/material.dart';
import 'package:focusnow/ui/start/onboarding/onboarding_demo.dart';
import 'package:focusnow/ui/study_timer/progress_display/study_timer_view.dart';
import 'package:focusnow/ui/study_timer/study_timer_page.dart';

class OnboardingPageModel {
  final Widget? demoWidget;
  final String imageAsset;
  final String title;
  final String description;

  const OnboardingPageModel({
    required this.demoWidget,
    required this.imageAsset,
    required this.title,
    required this.description,
  });
}

const onboardingPages = [
  OnboardingPageModel(
    demoWidget: null,
    imageAsset: 'assets/onboarding/onboarding1.png',
    title: "No more feeling stuck.",
    description: "Turn overwhelm into small wins you can see",
  ),
  OnboardingPageModel(
    demoWidget: null,
    imageAsset: 'assets/onboarding/onboarding2.png',
    title: "Starting is the hardest part.",
    description: "Stay consistent, level up, and beat procrastination",
  ),
  OnboardingPageModel(
    demoWidget: OnboardingDemo(),
    imageAsset: 'assets/onboarding/onboarding2.png',
    title: "Lets start small.",
    description: "That's how progress begins.",
  ),
];
