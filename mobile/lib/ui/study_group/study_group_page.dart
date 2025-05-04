import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/study_group/study_group_bloc.dart';
import 'package:focusnow/ui/study_group/group_tile.dart';
import 'package:focusnow/ui/study_group/study_group_detail_page.dart';
import 'package:study_group_repository/study_group_repository.dart';

class StudyGroupPage extends StatefulWidget {
  const StudyGroupPage({super.key});

  @override
  State<StudyGroupPage> createState() => _StudyGroupPageState();
}

class _StudyGroupPageState extends State<StudyGroupPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<StudyGroupBloc>().add(NextPage());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Groups')),
      body: BlocBuilder<StudyGroupBloc, StudyGroupState>(
        builder: (context, state) {
          if (state.isLoading && state.groups.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Only Joined'),
                      selected: state.showJoined,
                      onSelected: (_) => context.read<StudyGroupBloc>().add(
                            ChangeShowJoined(showJoined: !state.showJoined),
                          ),
                    ),
                    const Spacer(),
                    DropdownButton<StudyGroupSortBy>(
                      value: state.sortBy,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<StudyGroupBloc>().add(
                                ChangeGroupSortBy(sortBy: value),
                              );
                        }
                      },
                      items: StudyGroupSortBy.values.map((sortOption) {
                        return DropdownMenuItem(
                          value: sortOption,
                          child: Text(sortOption.displayName),
                        );
                      }).toList(),
                    ),
                    IconButton(
                      icon: Icon(state.ascending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward),
                      onPressed: () {
                        context.read<StudyGroupBloc>().add(
                              ChangeGroupSortOrder(ascending: !state.ascending),
                            );
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: state.groups.length,
                  itemBuilder: (context, index) {
                    return GroupTile(group: state.groups[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 16);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
