import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_timer/features/navigation/widgets/navigation_button.dart';
import 'package:study_timer/features/themes/light_dark_themes.dart';
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

  void onScreenChange(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: Container(
        height: 100,
        padding: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: lightNavigationBar,
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
                  ? FluentIcons.calendar_12_filled
                  : FluentIcons.calendar_12_regular,
              text: "Today",
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
