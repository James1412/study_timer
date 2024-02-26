import 'package:flutter/material.dart';
import 'package:study_timer/screens/navigation_screen.dart';
import 'package:study_timer/utils/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudyTimerApp());
}

class StudyTimerApp extends StatelessWidget {
  const StudyTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: const NavigationScreen(),
    );
  }
}
