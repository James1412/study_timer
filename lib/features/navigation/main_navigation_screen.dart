import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_timer/features/navigation/widgets/navigation_button.dart';
import 'package:study_timer/features/today_record/home_screen.dart';
import 'package:study_timer/features/stats/stats_screen.dart';
import 'package:study_timer/features/timer/timer_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int index = 0;
  List<Widget> screens = [
    const TimerScreen(),
    const HomeScreen(),
    const StatsScreen(),
  ];

  void changeScreen(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Row(
          children: [
            NavigationButton(
                icon: index == 0
                    ? FluentIcons.timer_12_filled
                    : FluentIcons.timer_12_regular,
                text: "Timer",
                onTap: changeScreen,
                index: 0),
            NavigationButton(
                icon: index == 1
                    ? FluentIcons.calendar_12_filled
                    : FluentIcons.calendar_12_regular,
                text: "Today",
                onTap: changeScreen,
                index: 1),
            NavigationButton(
                icon: index == 2
                    ? FluentIcons.chart_multiple_20_filled
                    : FluentIcons.chart_multiple_20_regular,
                text: "Stats",
                onTap: changeScreen,
                index: 2),
          ],
        ),
      ),
    );
  }
}
