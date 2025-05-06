import 'package:auto_size_text/auto_size_text.dart';
import 'package:focusnow/ui/login/login.dart';
import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:focusnow/ui/start/onboarding/onboarding_screen.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  static Page<void> page() => MaterialPage<void>(child: StartPage());

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    AnalyticsRepository().logScreen("Start Page");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: "Onboarding"),
            builder: (context) => const OnboardingScreen(),
          ),
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 20), // Top padding
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: Row(
                          children: [
                            Transform.translate(
                              offset: Offset(0, -4),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: Image.asset(
                                  'assets/icon_round.png',
                                  height: 80,
                                ),
                              ),
                            ),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: AutoSizeText(
                                  'FocusNow',
                                  maxLines: 1,
                                  style: theme.textTheme.displayLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 54,
                            child: FilledButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings:
                                        const RouteSettings(name: "Onboarding"),
                                    builder: (context) =>
                                        const OnboardingScreen(),
                                  ),
                                );
                              },
                              child: const Text('Get Started'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 54,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings:
                                        const RouteSettings(name: "LoginPage"),
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              child: const Text('Login'),
                            ),
                          ),
                          const SizedBox(height: 12)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
