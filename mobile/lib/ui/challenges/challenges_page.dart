import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/challenge/challenge_bloc.dart';
import 'package:focusnow/ui/challenges/category_filter_bar.dart';
import 'package:focusnow/ui/challenges/challenge_tile.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  @override
  void initState() {
    super.initState();
    AnalyticsRepository().logScreen("challenges_page");
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ChallengeBloc>().add(LoadChallenges());
        AnalyticsRepository().logEvent("challenges_page_refreshed");
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Challenges'),
          scrolledUnderElevation: 0.0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CategoryFilterBar(),
            const SizedBox(height: 2),
            CompletedCounter(),
            Expanded(child: ChallengeList()),
          ],
        ),
      ),
    );
  }
}

@visibleForTesting
class ChallengeList extends StatelessWidget {
  const ChallengeList({super.key});

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

@visibleForTesting
class CompletedCounter extends StatelessWidget {
  const CompletedCounter({super.key});

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
