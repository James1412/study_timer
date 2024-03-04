import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_timer/features/home/home_screen.dart';
import 'package:study_timer/features/navigation/widgets/navigation_button.dart';
import 'package:study_timer/features/stats/stats_screen.dart';
import 'package:study_timer/features/timer/timer_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int index = 0;

  void onScreenChange(int newIndex) {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Offstage(
            offstage: index != 0,
            child: const TimerScreen(),
          ),
          if (index == 1) const HomeScreen(),
          Offstage(
            offstage: index != 2,
            child: const StatsScreen(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 85,
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: const Border(
              top: BorderSide(
            color: Colors.grey,
            width: 0.3,
          )),
        ),
        child: Row(
          children: [
            NavigationButton(
              icon: index == 0
                  ? FluentIcons.timer_12_filled
                  : FluentIcons.timer_12_regular,
              text: "Timer",
              onTap: onScreenChange,
              index: 0,
            ),
            NavigationButton(
              icon: index == 1
                  ? FluentIcons.home_12_filled
                  : FluentIcons.home_12_regular,
              text: "Home",
              onTap: onScreenChange,
              index: 1,
            ),
            NavigationButton(
              icon: index == 2
                  ? FluentIcons.chart_multiple_20_filled
                  : FluentIcons.chart_multiple_20_regular,
              text: "Stats",
              onTap: onScreenChange,
              index: 2,
            ),
          ],
        ),
      ),
    );
  }
}
