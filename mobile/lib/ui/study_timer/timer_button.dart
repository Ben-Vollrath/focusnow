import 'package:flutter/material.dart';

class TimerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final double iconSize;

  const TimerButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: iconSize,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
