import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:focusnow/bloc/stats/stats_bloc.dart';
import 'package:focusnow/ui/stats/stats_share_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stats_repository/daily_study_data.dart';

int getTodayMinutes(List<DailyStudyData> weeklyData) {
  final today = DateTime.now();
  final todayStr = DateTime(today.year, today.month, today.day)
      .toIso8601String()
      .split('T')
      .first;

  final todayEntry = weeklyData.firstWhere(
    (e) => e.studyDate == todayStr,
    orElse: () => DailyStudyData(
      studyDate: todayStr,
      totalStudyTime: 0,
      totalStudySessions: 0,
      streakDay: 0,
    ),
  );

  return todayEntry.totalStudyTime ?? 0;
}

int getTodaySessions(List<DailyStudyData> weeklyData) {
  final today = DateTime.now();
  final todayStr = DateTime(today.year, today.month, today.day)
      .toIso8601String()
      .split('T')
      .first;

  final todayEntry = weeklyData.firstWhere(
    (e) => e.studyDate == todayStr,
    orElse: () => DailyStudyData(
      studyDate: todayStr,
      totalStudyTime: 0,
      totalStudySessions: 0,
      streakDay: 0,
    ),
  );

  return todayEntry.totalStudySessions ?? 0;
}

int getCurrentStreak(List<DailyStudyData> weeklyData) {
  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);

  // Convert studyData to a map for fast lookup
  final studyMap = {
    for (final data in weeklyData)
      DateTime.parse(data.studyDate): data.totalStudyTime ?? 0
  };

  int streak = 0;

  // Check consecutive days backwards from today
  for (int i = 0; i < 7; i++) {
    final date = todayDate.subtract(Duration(days: i));
    final studyTime = studyMap[date] ?? 0;

    if (studyTime > 0) {
      streak++;
    } else {
      break; // streak ends
    }
  }

  return streak;
}

Future<void> captureAndShareStatsImage({
  required BuildContext context,
}) async {
  final shareKey = GlobalKey();

  final overlay = Overlay.of(context);
  final entry = OverlayEntry(
    maintainState: true,
    builder: (context) {
      return Positioned(
        // Move far offscreen so it won’t be visible but still paints
        top: 10000,
        left: 10000,
        child: Material(
          type: MaterialType.transparency,
          child: Transform.translate(
            offset: const Offset(0, 0), // Trick: Flutter thinks it's visible
            child: RepaintBoundary(
              key: shareKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: StatsShareView(),
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(entry);

  try {
    await Future.delayed(const Duration(milliseconds: 100));
    await WidgetsBinding.instance.endOfFrame;

    final boundary =
        shareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null || boundary.debugNeedsPaint) {
      await Future.delayed(const Duration(milliseconds: 100));
      return captureAndShareStatsImage(context: context); // retry once
    }

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final directory = await getTemporaryDirectory();
    final imagePath = File('${directory.path}/FocusNow_StatsShare.png');
    await imagePath.writeAsBytes(pngBytes);

    await SharePlus.instance.share(ShareParams(
      files: [XFile(imagePath.path)],
    ));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Couldnt share stats, try a gain later')),
    );
  } finally {
    entry.remove();
  }
}
