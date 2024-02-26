import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:study_timer/screens/home_screen.dart';
import 'package:study_timer/screens/stats_screen.dart';
import 'package:study_timer/utils/themes.dart';
import 'package:study_timer/widgets/navigation_icon.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> screens = [const HomeScreen(), const StatsScreen()];
  int index = 0;
  void onTap(int selectedIndex) {
    setState(() {
      index = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: NavigationIcon(
                onTap: onTap,
                index: 0,
                icon: index == 0 ? Icons.timer : Icons.timer_outlined,
                label: "Timer",
                color:
                    index != 0 ? colors[AppThemeColors.baseBeigeColor] : null,
              ),
            ),
            Expanded(
              child: NavigationIcon(
                onTap: onTap,
                index: 1,
                icon: index == 1
                    ? FluentIcons.chart_multiple_20_filled
                    : FluentIcons.chart_multiple_20_regular,
                label: "Stats",
                color:
                    index != 1 ? colors[AppThemeColors.baseBeigeColor] : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
