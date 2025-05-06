import 'package:challenge_repository/challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    const categories = ChallengeCategory.values;
    final state = context.watch<ChallengeBloc>().state;

    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        itemBuilder: (_, index) {
          final isAll = index == 0;
          final category = isAll ? null : categories[index - 1];

          final isSelected = isAll
              ? state.selectedCategory == null
              : state.selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(isAll ? 'All' : category!.display_name),
              selected: isSelected,
              onSelected: (_) {
                context.read<ChallengeBloc>().add(FilterByCategory(category));
              },
            ),
          );
        },
      ),
    );
  }
}
