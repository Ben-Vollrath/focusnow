import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageAsset, height: 180),
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
            style:
                theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
