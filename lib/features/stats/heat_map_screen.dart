import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:provider/provider.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/home/view_models/study_session_vm.dart';
import 'package:study_timer/features/themes/colors.dart';
import 'package:study_timer/features/themes/dark%20mode/utils.dart';

class HeatMapScreen extends StatefulWidget {
  const HeatMapScreen({super.key});

  @override
  State<HeatMapScreen> createState() => _HeatMapScreenState();
}

class _HeatMapScreenState extends State<HeatMapScreen> {
  Map<DateTime, int> getDatasets() {
    Map<DateTime, int> datasets = {};
    for (DateTime date in context.watch<StudySessionViewModel>().studyDates) {
      int duration = 0;
      for (StudySessionModel studySessionModel
          in context.watch<StudySessionViewModel>().studySessions) {
        if (isSameDate(date, studySessionModel.date)) {
          duration += studySessionModel.duration.inMinutes;
        }
      }
      duration = (duration / 60).round();
      datasets.addEntries({date: duration}.entries);
    }
    return datasets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            HeatMapCalendar(
              colorsets: {
                1: blueButtonColor,
              },
              defaultColor:
                  isDarkMode(context) ? darkNavigationBar : lightNavigationBar,
              textColor: isDarkMode(context) ? Colors.white : Colors.black,
              flexible: true,
              colorMode: ColorMode.opacity,
              datasets: getDatasets(),
            ),
          ],
        ),
      ),
    );
  }
}
