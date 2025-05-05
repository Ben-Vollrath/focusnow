import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/study_group/study_group_bloc.dart';
import 'package:focusnow/ui/study_group/study_group_detail_page.dart';
import 'package:focusnow/ui/widgets/duration_text.dart';
import 'package:focusnow/ui/widgets/flat_container.dart';
import 'package:focusnow/ui/widgets/icon_badge.dart';
import 'package:intl/intl.dart';
import 'package:study_group_repository/study_group.dart';

class GroupTile extends StatelessWidget {
  final StudyGroup group;

  const GroupTile({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<StudyGroupBloc>().add(SelectGroup(group));
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: "Group Detail"),
            builder: (context) => StudyGroupDetailPage(),
          ),
        );
      },
      child: FlatContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(group.name,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (group.isJoined)
                  IconBadge(
                      icon: Icon(Icons.check),
                      text: "Joined",
                      tooltipMessage: "You joined this group"),
              ],
            ),
            const SizedBox(height: 8),
            Text(group.description, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconBadge(
                    icon: const Icon(Icons.person_sharp,
                        size: 16, color: Colors.orange),
                    text: group.memberCount.toString(),
                    tooltipMessage: "Group Members"),
                IconBadge(
                    icon:
                        const Icon(Icons.timer, size: 16, color: Colors.orange),
                    text: group.goalMinutes != null || group.goalMinutes == 0
                        ? formatDuration(group.goalMinutes!)
                        : "-",
                    tooltipMessage: "Current Group Goal"),
                IconBadge(
                    icon: const Icon(Icons.calendar_month_outlined,
                        size: 16, color: Colors.orange),
                    text: group.goalDate != null
                        ? DateFormat.yMMMd().format(group.goalDate!)
                        : "-",
                    tooltipMessage: "Group Goal Date"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
