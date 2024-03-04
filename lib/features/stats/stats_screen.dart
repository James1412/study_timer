import 'package:duration/duration.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/home/view%20models/study_session_vm.dart';
import 'package:study_timer/features/settings/settings_screen.dart';
import 'package:study_timer/features/themes/dark%20mode/utils.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<DateTime, int> getDatasets(BuildContext context) {
    Map<DateTime, int> datasets = {};
    for (DateTime date in context.watch<StudySessionViewModel>().studyDates) {
      int duration = 0;
      for (StudySessionModel studySessionModel
          in context.watch<StudySessionViewModel>().studySessions) {
        if (isSameDate(date, studySessionModel.date)) {
          duration += studySessionModel.duration.inMinutes;
        }
      }
      datasets.addEntries({date: duration}.entries);
    }
    return datasets;
  }

  @override
  Widget build(BuildContext context) {
    StudySessionViewModel viewModel =
        Provider.of<StudySessionViewModel>(context);

    List<StudySessionModel> sessionsPastThirtyDays = viewModel.studySessions
        .where(
          (session) => session.date.isAfter(DateTime.now().subtract(
            const Duration(days: 30),
          )),
        )
        .toList();

    Duration totalStudyTimePastThirty = sessionsPastThirtyDays.fold(
        Duration.zero,
        (previousValue, session) => previousValue + session.duration);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(FluentIcons.settings_28_regular),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            width: double.maxFinite,
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(
                  color: isDarkMode(context)
                      ? const Color(0xff444652)
                      : const Color(0xffDEDEDE)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Study Time",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  const Gap(5),
                  Text(
                    prettyDuration(
                      totalStudyTimePastThirty,
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
                      "Past 30 days",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Gap(10),
                ],
              ),
            ),
          ),
          HeatMapCalendar(
            colorsets: const {
              1: Colors.red,
              2: Colors.orange,
              3: Colors.yellow,
              4: Colors.green,
              5: Colors.blue,
              6: Colors.indigo,
              7: Colors.purple,
            },
            flexible: true,
            colorMode: ColorMode.opacity,
            datasets: getDatasets(context),
          ),
        ],
      ),
    );
  }
}
