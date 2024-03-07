import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_timer/features/navigation/main_navigation_screen.dart';
import 'package:study_timer/features/themes/dark%20mode/dark_mode_vm.dart';
import 'package:study_timer/features/themes/light_dark_themes.dart';
import 'package:study_timer/utils/hive_box_const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(darkmodeHiveBoxConst);
  await Hive.openBox(autoBrightnessHiveBoxConst);
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
