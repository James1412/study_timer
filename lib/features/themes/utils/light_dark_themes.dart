import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/themes/utils/colors.dart';

ThemeData lightTheme(WidgetRef ref) => ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground(ref),
      textTheme: Typography.blackCupertino,
      colorScheme: ColorScheme.light(
        secondary: lightNavigationBar,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: lightBackground(ref),
        surfaceTintColor: lightBackground(ref),
        shadowColor: lightBackground(ref),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );

ThemeData darkTheme(WidgetRef ref) => ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground(ref),
      textTheme: Typography.whiteCupertino,
      colorScheme: ColorScheme.dark(
        secondary: darkNavigationBar(ref),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: darkBackground(ref),
        surfaceTintColor: darkBackground(ref),
        shadowColor: darkBackground(ref),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
