import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_timer/features/navigation/main_navigation_screen.dart';
import 'package:study_timer/features/themes/view_models/dark_mode_vm.dart';
import 'package:study_timer/features/themes/models/main_color_model.dart';
import 'package:study_timer/features/themes/utils/light_dark_themes.dart';
import 'package:study_timer/utils/hive_box_const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hiveInit();
  runApp(
    const ProviderScope(
      child: StudyTimerApp(),
    ),
  );
}

Future<void> hiveInit() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MainColorsAdapter());
  await Hive.openBox(darkmodeHiveBoxConst);
  await Hive.openBox(autoBrightnessHiveBoxConst);
  await Hive.openBox<MainColors>(mainColorHiveBoxConst);
}

class StudyTimerApp extends ConsumerWidget {
  const StudyTimerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(ref),
      darkTheme: darkTheme(ref),
      themeMode: ref.watch(darkmodeProvider) ? ThemeMode.dark : ThemeMode.light,
      home: const MainNavigationScreen(),
    );
  }
}
