import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/study_group/study_group_bloc.dart';
import 'package:focusnow/ui/leaderboard/leaderboard_tile.dart';
import 'package:focusnow/ui/study_group/goal_leaderboard_tile.dart';
import 'package:study_group_repository/goal_leaderboard_entry.dart';
import 'package:study_group_repository/leaderboard_entry.dart';
import 'package:study_group_repository/study_group.dart';
import 'package:study_group_repository/study_group_repository.dart';

class StudyGroupDetailPage extends StatefulWidget {
  final StudyGroup group;

  const StudyGroupDetailPage({super.key, required this.group});

  @override
  State<StudyGroupDetailPage> createState() => _StudyGroupDetailPageState();
}

class _StudyGroupDetailPageState extends State<StudyGroupDetailPage> {
  String leaderboardType = 'goal';

  @override
  void initState() {
    super.initState();
    context.read<StudyGroupBloc>().add(FetchLeaderboards(widget.group.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name)),
      body: BlocBuilder<StudyGroupBloc, StudyGroupState>(
        builder: (context, state) {
          final leaderboard = switch (leaderboardType) {
            'goal' => state.goalLeaderboard,
            'daily' => state.dailyLeaderboard,
            'total' => state.totalLeaderboard,
            _ => []
          };

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.group.description),
                const SizedBox(height: 8),
                Text('Members: ${widget.group.memberCount}'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Goal'),
                      selected: leaderboardType == 'goal',
                      onSelected: (_) =>
                          setState(() => leaderboardType = 'goal'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Daily'),
                      selected: leaderboardType == 'daily',
                      onSelected: (_) =>
                          setState(() => leaderboardType = 'daily'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Total'),
                      selected: leaderboardType == 'total',
                      onSelected: (_) =>
                          setState(() => leaderboardType = 'total'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: leaderboard.length,
                    itemBuilder: (context, index) {
                      final entry = leaderboard[index];
                      switch (entry) {
                        case StudyGroupLeaderboardEntry _:
                          return LeaderboardTile(
                            rank: entry.rank,
                            userName: entry.userName,
                            studyMinutes: entry.totalStudyTime,
                            studySessions: entry.totalStudySessions,
                            isCurrentUser: entry.isCurrentUser,
                          );
                        case GoalLeaderboardEntry _:
                          return GoalLeaderboardTile(
                            userName: entry.userName,
                            rank: index + 1,
                            currentMinutes: entry.currentMinutes,
                            goalMinutes: widget.group.goalMinutes!,
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
