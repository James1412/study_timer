import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/navigation/main_navigation_screen.dart';
import 'package:study_timer/features/themes/dark%20mode/dark_mode_vm.dart';
import 'package:study_timer/features/themes/light_dark_themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: StudyTimerApp(),
    ),
  );
}

class StudyTimerApp extends ConsumerWidget {
  const StudyTimerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ref.watch(darkmodeProvider) ? ThemeMode.dark : ThemeMode.light,
      home: const MainNavigationScreen(),
    );
  }
}
