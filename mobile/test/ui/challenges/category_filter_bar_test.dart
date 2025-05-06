import 'package:bloc_test/bloc_test.dart';
import 'package:challenge_repository/challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/ui/challenges/category_filter_bar.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';

class MockChallengeBloc extends MockBloc<ChallengeEvent, ChallengeState>
    implements ChallengeBloc {}

void main() {
  late MockChallengeBloc mockBloc;

  setUp(() {
    mockBloc = MockChallengeBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<ChallengeBloc>.value(
          value: mockBloc,
          child: const CategoryFilterBar(),
        ),
      ),
    );
  }

  testWidgets('displays All and all ChallengeCategory chips', (tester) async {
    when(() => mockBloc.state).thenReturn(ChallengeState.initial());

    await tester.pumpWidget(buildTestWidget());

    expect(find.text('All'), findsOneWidget);
    for (final category in ChallengeCategory.values) {
      expect(find.text(category.display_name), findsOneWidget);
    }
  });

  testWidgets('highlights selected category', (tester) async {
    const selectedCategory = ChallengeCategory.total_sessions;

    when(() => mockBloc.state).thenReturn(
      ChallengeState.initial().copyWith(selectedCategory: selectedCategory),
    );

    await tester.pumpWidget(buildTestWidget());

    final selectedChip =
        find.widgetWithText(ChoiceChip, selectedCategory.display_name);
    final allChip = find.widgetWithText(ChoiceChip, 'All');

    expect(tester.widget<ChoiceChip>(selectedChip).selected, true);
    expect(tester.widget<ChoiceChip>(allChip).selected, false);
  });

  testWidgets('tapping a chip dispatches FilterByCategory event',
      (tester) async {
    when(() => mockBloc.state).thenReturn(ChallengeState.initial());

    await tester.pumpWidget(buildTestWidget());

    final chipToTap = find.text('Daily Sessions');
    await tester.tap(chipToTap);
    await tester.pumpAndSettle();

    verify(() =>
            mockBloc.add(FilterByCategory(ChallengeCategory.daily_sessions)))
        .called(1);
  });
}
