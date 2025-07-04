import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/study_timer/study_timer_bloc.dart';
import 'package:focusnow/ui/leaderboard/leaderboard_page.dart';
import 'package:focusnow/ui/study_group/study_group_page.dart';
import 'package:focusnow/ui/study_timer/study_timer_page.dart';
import 'package:focusnow/ui/challenges/challenges_page.dart';
import 'package:focusnow/ui/stats/stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 2);
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    const LeaderboardPage(),
    const StatsPage(),
    const StudyTimerPage(),
    const ChallengesPage(),
    const StudyGroupPage()
  ];

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StudyTimerBloc, StudyTimerState>(
        builder: (context, state) {
          return PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: state.canInteractOutsideTimer
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            children: _pages,
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<StudyTimerBloc, StudyTimerState>(
        builder: (context, state) {
          final isVisible = state.status != TimerStatus.running;

          return AnimatedSlide(
            offset: isVisible ? Offset.zero : const Offset(0, 1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              opacity: isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      width: 1,
                    ),
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.leaderboard_outlined),
                        label: 'Leaderboard',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.show_chart_outlined),
                        label: 'Stats',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.hourglass_bottom_outlined),
                        label: 'Timer',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.emoji_events_outlined),
                        label: 'Challenges',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.group_outlined),
                        label: 'Study Groups',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
