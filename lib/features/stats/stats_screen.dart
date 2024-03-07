import 'package:duration/duration.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/view_models/study_session_vm.dart';
import 'package:study_timer/features/settings/settings_screen.dart';
import 'package:study_timer/features/stats/heat_map_screen.dart';
import 'package:study_timer/features/stats/widgets/grid_stat_box.dart';
import 'package:study_timer/features/stats/widgets/subject_stat_box.dart';
import 'package:study_timer/features/themes/utils/colors.dart';
import 'package:study_timer/features/themes/view_models/main_color_vm.dart';
import 'package:study_timer/utils/ios_haptic.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    List<StudySessionModel> sessionsPastSevenDays = ref
        .watch(studySessionProvider)
        .where(
          (session) => session.date.isAfter(DateTime.now().subtract(
            const Duration(days: 7),
          )),
        )
        .toList();

    Duration totalStudyTimePastSeven = sessionsPastSevenDays.fold(Duration.zero,
        (previousValue, session) => previousValue + session.duration);

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
          Container(
            width: double.maxFinite,
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(color: getStatsBoxColor(ref)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HeatMapScreen()),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Study Time",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Icon(FluentIcons.calendar_16_regular),
                          ],
                        ),
                      ),
                      const Gap(5),
                      Text(
                        prettyDuration(
                          totalStudyTimePastSeven,
                          tersity: DurationTersity.minute,
                          upperTersity: DurationTersity.hour,
                        ),
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                      const Gap(5),
                      const Opacity(
                        opacity: 0.7,
                        child: Text(
                          "Past 7 days",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Gap(10),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: ref.watch(mainColorProvider).withOpacity(0.05),
                  ),
                ),
              ],
            ),
          ),
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
