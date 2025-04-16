import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:focusnow/ui/challenges/category_filter_bar.dart';
import 'package:focusnow/ui/challenges/challenge_tile.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
        scrolledUnderElevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategoryFilterBar(),
          const SizedBox(height: 2),
          _CompletedCounter(),
          Expanded(child: _ChallengeList()),
        ],
      ),
    );
  }
}

class _ChallengeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengeBloc, ChallengeState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == Status.loaded) {
          if (state.challenges.isEmpty) {
            return const Center(child: Text('No challenges found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: state.challenges.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return ChallengeTile(entry: state.challenges[index]);
            },
          );
        } else {
          return const Center(child: Text('Failed to load challenges.'));
        }
      },
    );
  }
}

class _CompletedCounter extends StatelessWidget {
  const _CompletedCounter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengeBloc, ChallengeState>(
      builder: (context, state) {
        if (state.status != Status.loaded) return const SizedBox.shrink();

        final completed =
            state.challenges.where((e) => e.progress?.completed == true).length;
        final total = state.challenges.length;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Completed: $completed / $total',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
        );
      },
    );
  }
}
