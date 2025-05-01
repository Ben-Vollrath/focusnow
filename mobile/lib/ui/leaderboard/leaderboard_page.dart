import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/bloc/leaderboard/leaderboard_bloc.dart';
import 'package:focusnow/ui/leaderboard/leaderboard_tile.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<LeaderboardBloc>().add(
            LoadLeaderboard(userId: context.read<AppBloc>().state.user.id));
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Leaderboard')),
        body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            if (state.status == LeaderBoardStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == LeaderBoardStatus.error) {
              return const Center(child: Text('Failed to load leaderboard'));
            }

            final leaderboard = state.selectedType == LeaderboardType.daily
                ? state.dailyLeaderboard
                : state.totalLeaderboard;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Wrap(
                          spacing: 8,
                          children: LeaderboardType.values.map((type) {
                            return ChoiceChip(
                              label: Text(type.name.toUpperCase()),
                              selected: state.selectedType == type,
                              onSelected: (_) => context
                                  .read<LeaderboardBloc>()
                                  .add(LeaderboardTypeChanged(type)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: leaderboard.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final entry = leaderboard[index];
                        return LeaderboardTile(
                            rank: index + 1,
                            userName: entry.name,
                            studyMinutes: entry.totalStudyTime,
                            studySessions: entry.totalStudySessions,
                            isCurrentUser: entry.isCurrentUser);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
