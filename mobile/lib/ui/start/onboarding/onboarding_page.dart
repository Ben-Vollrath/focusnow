import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final Widget? demoWidget;
  final String? imageAsset;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.demoWidget,
    required this.imageAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (demoWidget != null)
          Expanded(child: demoWidget!)
        else
          Image.asset(imageAsset!, height: 500),
        const SizedBox(height: 48),
        Text(
          title,
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
