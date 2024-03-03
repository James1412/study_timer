import 'package:flutter/material.dart';
import 'package:study_timer/features/themes/colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xfff2f2f2),
  textTheme: Typography.blackCupertino,
  colorScheme: ColorScheme.light(
    secondary: lightNavigationBar,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: lightBackground,
    surfaceTintColor: lightBackground,
    shadowColor: lightBackground,
    titleTextStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkBackground,
  textTheme: Typography.whiteCupertino,
  colorScheme: ColorScheme.dark(
    secondary: darkNavigationBar,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: darkBackground,
    surfaceTintColor: darkBackground,
    shadowColor: darkBackground,
    titleTextStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  ),
);
