import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/login/login_cubit.dart';
import 'package:focusnow/ui/paywall/paywall.dart';
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

  void _nextPage() async {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await context.read<LoginCubit>().signIgnAnonymously();
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
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _nextPage,
          child: SafeArea(
            child: Column(
              children: [
                // Top: Back + Centered Progress Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            value: (_currentPage + 1) / onboardingPages.length,
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
                        imageAsset: page.imageAsset,
                        title: page.title,
                        description: page.description,
                      );
                    },
                  ),
                ),

                // Tap to continue
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    "TAP TO CONTINUE",
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
    );
  }
}
