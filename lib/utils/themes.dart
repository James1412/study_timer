import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  textTheme: Typography.blackCupertino,
  appBarTheme: const AppBarTheme(
    backgroundColor: CupertinoColors.white,
    shadowColor: CupertinoColors.white,
    surfaceTintColor: CupertinoColors.white,
  ),
  scaffoldBackgroundColor: CupertinoColors.white,
  bottomAppBarTheme: const BottomAppBarTheme(
    color: CupertinoColors.white,
    shadowColor: CupertinoColors.white,
    surfaceTintColor: CupertinoColors.white,
  ),
);
ThemeData darkTheme = ThemeData(
  textTheme: Typography.whiteCupertino,
  appBarTheme: const AppBarTheme(
    shadowColor: CupertinoColors.darkBackgroundGray,
    backgroundColor: CupertinoColors.darkBackgroundGray,
    surfaceTintColor: CupertinoColors.darkBackgroundGray,
    foregroundColor: CupertinoColors.white,
  ),
  scaffoldBackgroundColor: CupertinoColors.darkBackgroundGray,
  bottomAppBarTheme: const BottomAppBarTheme(
    color: CupertinoColors.darkBackgroundGray,
    shadowColor: CupertinoColors.darkBackgroundGray,
    surfaceTintColor: CupertinoColors.darkBackgroundGray,
  ),
);

enum AppThemeColors {
  mainThemeColor,
  baseBeigeColor,
  lightBeigeColor,
}

Map<AppThemeColors, Color> colors = {
  AppThemeColors.mainThemeColor: const Color(0xFFF14E0E),
  AppThemeColors.baseBeigeColor: const Color(0xffAA9387),
  AppThemeColors.lightBeigeColor: const Color(0xffF5F3F1),
};
