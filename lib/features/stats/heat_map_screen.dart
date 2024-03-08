import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/home/view_models/study_session_vm.dart';
import 'package:study_timer/features/themes/utils/colors.dart';
import 'package:study_timer/features/themes/view_models/dark_mode_vm.dart';
import 'package:study_timer/features/themes/view_models/main_color_vm.dart';
import 'package:study_timer/utils/ios_haptic.dart';

class HeatMapCalendarScreen extends ConsumerStatefulWidget {
  const HeatMapCalendarScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeatMapScreenState();
}

class _HeatMapScreenState extends ConsumerState<HeatMapCalendarScreen> {
  Map<DateTime, int> getDatasets() {
    Map<DateTime, int> datasets = {};
    final dates = ref.watch(studyDatesProvider);
    final studySessions = ref.watch(studySessionProvider);
    for (DateTime date in dates) {
      int duration = 0;
      for (StudySessionModel studySessionModel in studySessions) {
        if (areSameDate(date, studySessionModel.date)) {
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
    return PopScope(
      onPopInvoked: (_) => iosLightFeedback(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Calendar"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              HeatMapCalendar(
                colorsets: {
                  1: ref.watch(mainColorProvider),
                },
                defaultColor: ref.watch(darkmodeProvider)
                    ? darkNavigationBar(ref)
                    : lightNavigationBar,
                textColor:
                    ref.watch(darkmodeProvider) ? Colors.white : Colors.black,
                flexible: true,
                colorMode: ColorMode.opacity,
                datasets: getDatasets(),
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ListTile(
                    title: Text("a"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
