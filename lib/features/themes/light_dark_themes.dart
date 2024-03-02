import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xfff2f2f2),
  textTheme: Typography.blackCupertino,
  appBarTheme: AppBarTheme(
    backgroundColor: lightBackground,
    surfaceTintColor: lightBackground,
    shadowColor: lightBackground,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkBackground,
  textTheme: Typography.whiteCupertino,
  appBarTheme: AppBarTheme(
    backgroundColor: darkBackground,
    surfaceTintColor: darkBackground,
    shadowColor: darkBackground,
  ),
);

Color darkBackground = const Color(0xff1C1D22);
Color darkNavigationBar = const Color(0xff22232A);
Color lightBackground = const Color(0xfff2f2f2);
Color lightNavigationBar = const Color(0x000fffff);
