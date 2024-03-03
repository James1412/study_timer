import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_timer/features/navigation/main_navigation_screen.dart';
import 'package:study_timer/features/themes/dark%20mode/dark_mode_mvvm.dart';
import 'package:study_timer/features/themes/dark%20mode/utils.dart';
import 'package:study_timer/features/themes/light_dark_themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DarkModelViewModel(),
        ),
      ],
      child: const StudyTimerApp(),
    ),
  );
}

class StudyTimerApp extends StatelessWidget {
  const StudyTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode(context) ? ThemeMode.dark : ThemeMode.light,
      home: const MainNavigationScreen(),
    );
  }
}
