import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/ui/stats/level_box.dart';
import 'package:focusnow/ui/widgets/rounded_progress_indicator.dart';

void main() {
  const testWidget = MaterialApp(
    home: Scaffold(
      body: LevelBox(
        levelIcon: '🦊',
        level: 5,
        levelName: 'Focused Fox',
        xp: 1200,
        xpToNext: 1500,
        progress: 1200,
        full_amount: 1500,
      ),
    ),
  );

  testWidgets('renders level icon, name, and level', (tester) async {
    await tester.pumpWidget(testWidget);

    expect(find.text('🦊'), findsOneWidget);
    expect(find.text('Focused Fox'), findsOneWidget);
    expect(find.text('Level 5'), findsOneWidget);
  });

  testWidgets('shows XP and progress text correctly', (tester) async {
    await tester.pumpWidget(testWidget);

    expect(find.text('Progress to Level 6'), findsOneWidget);
    expect(find.text('1200 / 1500 XP'), findsOneWidget);
  });

  testWidgets('uses RoundedProgressIndicator with correct values',
      (tester) async {
    await tester.pumpWidget(testWidget);

    final progressIndicator = tester.widget<RoundedProgressIndicator>(
      find.byType(RoundedProgressIndicator),
    );

    expect(progressIndicator.progress, 1200);
    expect(progressIndicator.fullAmount, 1500);
  });

  testWidgets('displays correctly when user is at max level (xpToNext == null)',
      (tester) async {
    const maxLevelWidget = MaterialApp(
      home: Scaffold(
        body: LevelBox(
          levelIcon: '👑',
          level: 99,
          levelName: 'Master Mind',
          xp: 9999,
          xpToNext: 9999,
          progress: 9999,
          full_amount: 9999,
        ),
      ),
    );

    await tester.pumpWidget(maxLevelWidget);

    expect(find.text('👑'), findsOneWidget);
    expect(find.text('Master Mind'), findsOneWidget);
    expect(find.text('Level 99'), findsOneWidget);
    expect(find.text('Progress to Level 100'), findsOneWidget);
    expect(find.text('9999 / 9999 XP'), findsOneWidget);
  });
}
