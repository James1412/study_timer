import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_timer/screens/timer_screen.dart';
import 'package:study_timer/utils/themes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List classes = [
    [
      'math',
      false,
    ],
    [
      'science',
      false,
    ],
    [
      'history',
      false,
    ],
    [
      'computer',
      false,
    ],
  ];

  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0,
        title: const Text(
          "Focus",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView.builder(
          itemCount: classes.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimerScreen(
                  title: classes[index][0],
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: colors[AppThemeColors.lightBeigeColor],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          FluentIcons.settings_16_regular,
                          color: classes[index][1]
                              ? null
                              : CupertinoColors.systemGrey,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "2hr 30min",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: classes[index][1]
                                  ? null
                                  : CupertinoColors.systemGrey,
                            ),
                          ),
                          Text(
                            classes[index][0],
                            style: TextStyle(
                              color: classes[index][1]
                                  ? colors[AppThemeColors.baseBeigeColor]
                                  : CupertinoColors.systemGrey,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: classes[index][1],
                    onChanged: (val) {
                      setState(() {
                        classes[index][1] = !classes[index][1];
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
