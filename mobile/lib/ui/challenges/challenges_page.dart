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
    return BlocProvider(
      create: (_) => ChallengeBloc(
        repository: ChallengeRepository(),
      )..add(LoadChallenges()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Challenges')),
        body: Column(
          children: [
            const CategoryFilterBar(),
            const SizedBox(height: 8),
            Expanded(child: _ChallengeList()),
          ],
        ),
      ),
    );
  }
}

class _ChallengeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengeBloc, ChallengeState>(
      builder: (context, state) {
        if (state is ChallengeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChallengeLoaded) {
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
