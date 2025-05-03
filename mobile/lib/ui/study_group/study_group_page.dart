import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/study_group/study_group_bloc.dart';
import 'package:study_group_repository/study_group_repository.dart';

class StudyGroupPage extends StatelessWidget {
  const StudyGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudyGroupBloc(StudyGroupRepository())
        ..add(FetchStudyGroups())
        ..add(FetchJoinedGroups()),
      child: const StudyGroupView(),
    );
  }
}

class StudyGroupView extends StatelessWidget {
  const StudyGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Groups')),
      body: BlocBuilder<StudyGroupBloc, StudyGroupState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Joined Groups',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...state.joinedGroups.map((group) => ListTile(
                    title: Text(group.name),
                    subtitle: Text(group.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () {
                        context
                            .read<StudyGroupBloc>()
                            .add(LeaveStudyGroup(group.id));
                      },
                    ),
                    onTap: () {
                      context
                          .read<StudyGroupBloc>()
                          .add(FetchLeaderboards(group.id));
                    },
                  )),
              const SizedBox(height: 24),
              const Text('Public Groups',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...state.groups.map((group) => ListTile(
                    title: Text(group.name),
                    subtitle: Text(group.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.group_add),
                      onPressed: () {
                        context
                            .read<StudyGroupBloc>()
                            .add(JoinStudyGroup(group.id));
                      },
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
