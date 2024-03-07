import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:study_timer/features/settings/settings_screen.dart';
import 'package:study_timer/features/stats/widgets/grid_stat_box.dart';
import 'package:study_timer/features/stats/widgets/study_line_chart.dart';
import 'package:study_timer/features/stats/widgets/subject_stat_box.dart';
import 'package:study_timer/utils/ios_haptic.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
        actions: [
          GestureDetector(
            onTap: () {
              iosLightFeedback();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(FluentIcons.settings_28_regular),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
        children: [
          const StudyLineChart(),
          const Gap(20),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1.3,
            children: const [
              GridStatBox(
                title: 'Average study time per day',
                stat: "3.8h",
              ),
              GridStatBox(
                title: 'Study sessions this week',
                stat: "34",
                change: '-20%',
              ),
              GridStatBox(
                title: 'Top subject this week',
                stat: "Science",
              ),
              GridStatBox(
                title: 'Longest study streak',
                stat: "7 day",
                change: "+10%",
              ),
            ],
          ),
          const Gap(16),
          const SubjectStatBox(),
        ],
      ),
    );
  }
}
