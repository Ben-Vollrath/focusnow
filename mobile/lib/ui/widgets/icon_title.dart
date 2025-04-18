import 'package:flutter/material.dart';

class IconTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final double offsetX;

  const IconTitle(
      {super.key, required this.title, required this.icon, this.offsetX = -7});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.translate(
          offset:
              Offset(offsetX, 0), // adjust this value to fine-tune alignment
          child: Icon(icon,
              size: 20, color: Theme.of(context).colorScheme.primary),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
