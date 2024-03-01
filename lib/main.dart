import 'package:flutter/material.dart';
import 'package:study_timer/features/navigation/main_navigation_screen.dart';
import 'package:study_timer/features/themes/light_dark_themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudyTimerApp());
}

class StudyTimerApp extends StatelessWidget {
  const StudyTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const MainNavigationScreen(),
    );
  }
}
