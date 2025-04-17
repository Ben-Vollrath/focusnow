import 'package:flutter/material.dart';

class DurationText extends StatelessWidget {
  final int minutes;
  final TextStyle? style;
  final bool showUnit;
  final bool showUnitShort;

  const DurationText({
    super.key,
    required this.minutes,
    this.style,
    this.showUnit = true,
    this.showUnitShort = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDuration(minutes, showUnit: showUnit),
      style: style,
    );
  }
}

String formatDuration(int minutes,
    {bool showUnit = true, bool showUnitShort = false}) {
  if (minutes >= 60) {
    final double hours = minutes / 60;
    final text =
        hours.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 1);
    return showUnit ? '$text h' : text;
  } else {
    return showUnit
        ? showUnitShort
            ? '$minutes m'
            : '$minutes min'
        : '$minutes';
  }
}
