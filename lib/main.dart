import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'data/activity_store.dart';
import 'login_screen.dart';

void main() {
  runApp(const HealthApp());
}

class HealthApp extends StatefulWidget {
  const HealthApp({super.key});

  @override
  State<HealthApp> createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  late final ActivityStore _activityStore;

  @override
  void initState() {
    super.initState();
    _activityStore = ActivityStore();
  }

  @override
  void dispose() {
    _activityStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthTrack',
      theme: AppTheme.light,
      home: OnboardingScreen(store: _activityStore),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.store});

  final ActivityStore store;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, dynamic>> pages = <Map<String, dynamic>>[
    <String, dynamic>{
      'icon': Icons.favorite_rounded,
      'title': 'Welcome to HealthTrack',
      'description': 'Your journey towards a healthier and more active lifestyle starts here.',
    },
    <String, dynamic>{
      'icon': Icons.monitor_heart_rounded,
      'title': 'Track Your Activities',
      'description': 'Keep track of your daily activities and build healthy habits.',
    },
    <String, dynamic>{
      'icon': Icons.health_and_safety_rounded,
      'title': 'Start Your Healthy Journey',
      'description': 'Stay motivated, monitor your progress, and improve your well-being.',
    },
  ];

  void _nextPage() {
    if (currentPage < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => LoginScreen(store: widget.store),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: (index) => setState(() => currentPage = index),
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: AppColors.mint,
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                page['icon'] as IconData,
                                size: 75,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              page['title'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.heading,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              page['description'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: currentPage == index ? 25 : 8,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? AppColors.primary
                            : const Color(0xFFBCD9D1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        currentPage == pages.length - 1 ? 'Get Started' : 'Next',
                        style: const TextStyle(fontSize: 17),
                      ),
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
