import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xfff2f2f2),
  textTheme: Typography.blackCupertino,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xfff2f2f2),
    surfaceTintColor: Color(0xfff2f2f2),
    shadowColor: Color(0xfff2f2f2),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: Typography.whiteCupertino,
  appBarTheme: const AppBarTheme(),
);
