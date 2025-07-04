import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/study_group/study_group_bloc.dart';
import 'package:focusnow/ui/study_group/create_group_sheet.dart';
import 'package:focusnow/ui/study_group/group_tile.dart';
import 'package:study_group_repository/study_group_repository.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return RefreshIndicator(
      onRefresh: () async {
        context.read<StudyGroupBloc>().add(FetchStudyGroups());
      },
      child: Scaffold(
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Study Groups'),
            IconButton(
              onPressed: () => _openCreateGroupSheet(context, (event) {
                context.read<StudyGroupBloc>().add(event);
              }),
              icon:
                  Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
            )
          ],
        )),
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
                  child: GestureDetector(
                    onTap: () async {
                      final url =
                          Uri.parse('https://www.reddit.com/r/FocusNow/');
                      await launchUrl(url);
                    },
                    child: Row(
                      children: [
                        Text('Find study groups in our SubReddit',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(200))),
                        const SizedBox(width: 8),
                        Image.asset('assets/reddit_logo.png',
                            width: 32, height: 32),
                      ],
                    ),
                  ),
                ),
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
                                ChangeGroupSortOrder(
                                    ascending: !state.ascending),
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
      ),
    );
  }

  void _openCreateGroupSheet(
      BuildContext context, void Function(CreateStudyGroup) onSubmit) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const StudyGroupInputSheet(),
    );

    if (result != null) {
      onSubmit(
        CreateStudyGroup(
          name: result['name'] as String,
          description: result['description'] as String,
          isPublic: result['isPublic'] as bool,
        ),
      );
    }
  }
}
