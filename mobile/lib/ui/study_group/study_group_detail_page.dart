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
import 'package:focusnow/ui/widgets/xp_badge.dart';
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
    final hasGoal = context
            .read<StudyGroupBloc>()
            .state
            .selectedGroup
            ?.goal
            ?.targetMinutes !=
        null;
    leaderboardType = hasGoal ? 'goal' : 'daily';
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AppBloc>().state.user.id;

    return BlocBuilder<StudyGroupBloc, StudyGroupState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {
                  if (state.selectedGroup!.isJoined) {
                    context.read<StudyGroupBloc>().add(LeaveStudyGroup());
                    if (state.selectedGroup!.ownerId == userId) {
                      Navigator.pop(context);
                    }
                  } else {
                    context.read<StudyGroupBloc>().add(JoinStudyGroup());
                  }
                },
                icon: state.selectedGroup?.isJoined ?? false
                    ? Icon(Icons.logout,
                        color: Theme.of(context).colorScheme.error)
                    : const Icon(Icons.login, color: Color(0xFF3FBF7F))),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(state.selectedGroup?.name ?? "",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                        onPressed: () =>
                            context.read<StudyGroupBloc>().add(ShareGroup()),
                        child: Row(
                          children: [
                            Icon(Icons.share),
                            const SizedBox(width: 4),
                            Text('Share'),
                          ],
                        ))
                  ],
                ),
                Text(state.selectedGroup?.description ?? "",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(200))),
                const SizedBox(height: 8),
                IconBadge(
                    icon: const Icon(Icons.person_sharp,
                        size: 16, color: Colors.orange),
                    text: state.selectedGroup?.memberCount.toString() ?? "-",
                    tooltipMessage: "Group Members"),
                const SizedBox(height: 16),
                _goalDisplay(state, context),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (state.selectedGroup?.goal?.targetMinutes != null)
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
                            goalMinutes:
                                state.selectedGroup?.goal?.targetMinutes ?? 0,
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
    final isOwner = state.selectedGroup?.ownerId == userId;

    return state.selectedGroup?.goal?.targetMinutes != null
        ? FlatContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        state.selectedGroup?.goal!.name ?? "",
                        style: Theme.of(context).textTheme.bodyLarge,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    if (isOwner)
                      GestureDetector(
                        child: const Icon(Icons.delete, color: Colors.red),
                        onTap: () {
                          context.read<StudyGroupBloc>().add(DeleteGroupGoal());
                        },
                      ),
                    XpBadge(
                        text:
                            "${state.selectedGroup?.goal!.xpReward.toString()} XP"),
                  ],
                ),
                const SizedBox(height: 4),
                Text(state.selectedGroup?.goal!.description ?? "",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(200))),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconBadge(
                      icon: const Icon(Icons.timer,
                          size: 16, color: Colors.orange),
                      text: formatDuration(
                        state.selectedGroup?.goal!.targetMinutes ?? 0,
                      ),
                      tooltipMessage: "Goal Time",
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(width: 8),
                    const SizedBox(width: 8),
                    IconBadge(
                        icon: Icon(Icons.calendar_month_outlined, size: 16),
                        text: state.selectedGroup?.goal?.targetDate != null
                            ? DateFormat.yMMMd()
                                .format(state.selectedGroup!.goal!.targetDate!)
                            : "",
                        tooltipMessage: "Goal Date"),
                  ],
                ),
              ],
            ),
          )
        : isOwner
            ? FlatContainer(
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Create Goal'),
                        onPressed: () async {
                          final input = await showModalBottomSheet<InputGoal>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
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
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink();
  }
}
