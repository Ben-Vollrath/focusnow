import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/bloc/goal/goal_bloc.dart';
import 'package:focusnow/bloc/study_group/study_group_bloc.dart';
import 'package:focusnow/ui/leaderboard/leaderboard_tile.dart';
import 'package:focusnow/ui/study_group/goal_input_sheet.dart';
import 'package:focusnow/ui/study_group/goal_leaderboard_tile.dart';
import 'package:focusnow/ui/widgets/duration_text.dart';
import 'package:focusnow/ui/widgets/flat_container.dart';
import 'package:focusnow/ui/widgets/icon_badge.dart';
import 'package:intl/intl.dart';
import 'package:study_group_repository/goal_leaderboard_entry.dart';
import 'package:study_group_repository/input_goal.dart';
import 'package:study_group_repository/leaderboard_entry.dart';
import 'package:study_group_repository/study_group.dart';
import 'package:study_group_repository/study_group_repository.dart';

class StudyGroupDetailPage extends StatefulWidget {
  @override
  State<StudyGroupDetailPage> createState() => _StudyGroupDetailPageState();
}

class _StudyGroupDetailPageState extends State<StudyGroupDetailPage> {
  String leaderboardType = 'daily';

  @override
  void initState() {
    super.initState();
    final hasGoal =
        context.read<StudyGroupBloc>().state.selectedGroup?.goalMinutes != null;
    leaderboardType = hasGoal ? 'goal' : 'daily';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudyGroupBloc, StudyGroupState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(state.selectedGroup!.name),
              IconButton(
                  onPressed: () {
                    if (state.selectedGroup!.isJoined) {
                      context.read<StudyGroupBloc>().add(LeaveStudyGroup());
                    } else {
                      context.read<StudyGroupBloc>().add(JoinStudyGroup());
                    }
                  },
                  icon: state.selectedGroup!.isJoined
                      ? Icon(Icons.logout,
                          color: Theme.of(context).colorScheme.error)
                      : const Icon(Icons.login, color: Color(0xFF3FBF7F))),
            ],
          )),
          body: BlocBuilder<StudyGroupBloc, StudyGroupState>(
            builder: (context, state) {
              final leaderboard = switch (leaderboardType) {
                'goal' => state.goalLeaderboard,
                'daily' => state.dailyLeaderboard,
                'total' => state.totalLeaderboard,
                _ => []
              };

              var list = [
                Text(state.selectedGroup!.description,
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                IconBadge(
                    icon: const Icon(Icons.person_sharp,
                        size: 16, color: Colors.orange),
                    text: state.selectedGroup!.memberCount.toString(),
                    tooltipMessage: "Group Members"),
                const SizedBox(height: 16),
                _goalDisplay(state, context),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (state.selectedGroup!.goalMinutes != null)
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text('Goal'),
                            selected: leaderboardType == 'goal',
                            onSelected: (_) =>
                                setState(() => leaderboardType = 'goal'),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
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
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
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
                            goalMinutes: state.selectedGroup!.goalMinutes!,
                          );
                      }
                    },
                  ),
                ),
              ];
              var children = list;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _goalDisplay(StudyGroupState state, BuildContext context) {
    final userId = context.read<AppBloc>().state.user.id;

    return state.selectedGroup!.goalMinutes != null
        ? FlatContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DurationText(
                  minutes: state.selectedGroup!.goalMinutes!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: 8),
                Text('-', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(width: 8),
                Icon(Icons.calendar_month_outlined,
                    size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  state.selectedGroup!.goalDate != null
                      ? DateFormat.yMMMd()
                          .format(state.selectedGroup!.goalDate!)
                      : "",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          )
        : state.selectedGroup!.ownerId == userId
            ? FlatContainer(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Create Goal'),
                  onPressed: () async {
                    final input = await showModalBottomSheet<InputGoal>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => const GoalInputSheet(),
                    );
                    if (input != null) {
                      context
                          .read<StudyGroupBloc>()
                          .add(CreateGroupGoal(inputGoal: input));
                    }
                  },
                ),
              )
            : const SizedBox.shrink();
  }
}
