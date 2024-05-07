// mainapp.dart
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  final Set<String> selectedActivities;

  const MainApp({required this.selectedActivities});

  @override
  Widget build(BuildContext context) {
    print('MainApp build: $selectedActivities');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
      ),
      body: ListView.builder(
        itemCount: selectedActivities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(selectedActivities.elementAt(index)),
          );
        },
      ),
    );
  }
}
