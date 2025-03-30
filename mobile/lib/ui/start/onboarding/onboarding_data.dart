class OnboardingPageModel {
  final String imageAsset;
  final String title;
  final String description;

  const OnboardingPageModel({
    required this.imageAsset,
    required this.title,
    required this.description,
  });
}

const onboardingPages = [
  OnboardingPageModel(
    imageAsset: 'assets/onboarding/onboarding1.png',
    title: "Welcome to FocusNow",
    description:
        "Your cozy corner for distraction-free studying. Built to help you focus and feel accomplished.",
  ),
  OnboardingPageModel(
    imageAsset: 'assets/onboarding/onboarding2.png',
    title: "Set the vibe & focus",
    description:
        "Use the timer to focus, track your streaks, and stay consistent.",
  ),
  OnboardingPageModel(
    imageAsset: 'assets/onboarding/onboarding3.png',
    title: "Earn XP and level up",
    description:
        "Each session earns XP. Level up, stay motivated, and make focus rewarding.",
  ),
  OnboardingPageModel(
    imageAsset: 'assets/onboarding/onboarding4.png',
    title: "Stay motivated",
    description:
        "Track your streaks, study time, and milestones — build habits that last.",
  ),
  OnboardingPageModel(
    imageAsset: 'assets/onboarding/onboarding5.png',
    title: "Make focus fun",
    description:
        "Complete daily & streak challenges to earn bonus XP and push your limits.",
  ),
];
