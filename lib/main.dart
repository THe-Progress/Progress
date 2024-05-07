// main.dart
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'mainapp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Progress',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<Widget> _onboardingScreens = [
    // Welcome Screen
    const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome to Progress!',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        Text(
          'This app is designed to help you stay focused and achieve your goals.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
    // Benefits Highlights
    const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Benefits Highlights',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        Text(
          'Track your progress and stay motivated with personalized reminders and rewards.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
    // User Permissions
    const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'User Permissions',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        Text(
          'Progress needs permission to send you notifications to keep you on track.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  ];
  Set<String> selectedActivities = {};

  @override
  void initState() {
    super.initState();
    selectedActivities = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                ..._onboardingScreens,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Personalization',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Select your preferred activities',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    ActivitySelection(selectedActivities: selectedActivities),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Get Started',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'You are all set! Tap the button below to start tracking your progress.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainApp(
                              selectedActivities: selectedActivities,
                            ),
                          ),
                        );
                      },
                      child: const Text('Get Started'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: _onboardingScreens.length + 2, // Added 2 for the new pages
            effect: const ScrollingDotsEffect(
              activeDotColor: Colors.blue,
              dotColor: Colors.grey,
              dotHeight: 10,
              dotWidth: 10,
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

const List<String> availableActivities = [
  'Coding',
  'Exercise',
  'Learning',
  'Reading',
  'Writing',
  'Meditation',
  'Cooking',
  'Gardening',
  // Add more activities as needed
];

class ActivitySelection extends StatefulWidget {
  final Set<String> selectedActivities;

  const ActivitySelection({super.key, required this.selectedActivities});

  @override
  State<ActivitySelection> createState() => _ActivitySelectionState();
}

class _ActivitySelectionState extends State<ActivitySelection> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: availableActivities.map((activity) {
        return FilterChip(
          label: Text(activity),
          selected: widget.selectedActivities.contains(activity),
          onSelected: (isSelected) {
            setState(() {
              if (isSelected) {
                widget.selectedActivities.add(activity);
              } else {
                widget.selectedActivities.remove(activity);
              }
            });
          },
        );
      }).toList(),
    );
  }
}
