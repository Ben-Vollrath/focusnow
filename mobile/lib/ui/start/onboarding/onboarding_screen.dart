import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/bloc/login/login_cubit.dart';
import 'package:focusnow/bloc/study_timer/study_timer_bloc.dart';
import 'onboarding_page.dart';
import 'onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _demoCompleted = false;
  get _demoPage => onboardingPages[_currentPage].demoWidget != null;

  @override
  void initState() {
    super.initState();
    context.read<LoginCubit>().signIgnAnonymously();
    AnalyticsRepository().logScreen("onboarding_screen");
  }

  void _handleTap() async {
    if (_demoPage && !_demoCompleted) {
      context.read<StudyTimerBloc>().add(StartTimer());
      return;
    }

    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      AnalyticsRepository().logScreen("onboarding_page: ${_currentPage + 1}");
    } else {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void _handleBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.read<AppBloc>().add(const AppLogoutRequested());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudyTimerBloc, StudyTimerState>(
      listenWhen: (previous, current) => current.status != previous.status,
      listener: (context, state) {
        if (state.status == TimerStatus.running) {
          AnalyticsRepository().logEvent("demo_started");
        }
        if (state.status == TimerStatus.completed ||
            state.status == TimerStatus.stopped) {
          AnalyticsRepository().logEvent("demo_completed");
          setState(() {
            _demoCompleted = true;
          });
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            _handleBack();
          }
        },
        child: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleTap,
            child: SafeArea(
              child: Column(
                children: [
                  // Top: Back + Centered Progress Bar
                  if (!_demoPage)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: _handleBack,
                          ),
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                minHeight: 6,
                                value:
                                    (_currentPage + 1) / onboardingPages.length,
                                backgroundColor: Colors.grey[300],
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),

                  // Page content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: onboardingPages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final page = onboardingPages[index];
                        return OnboardingPage(
                          demoWidget: page.demoWidget,
                          imageAsset: page.imageAsset,
                          title: page.title,
                          description: page.description,
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      (_demoPage && !_demoCompleted)
                          ? "TAP TO START"
                          : "TAP TO CONTINUE",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
