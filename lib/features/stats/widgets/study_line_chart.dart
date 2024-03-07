import 'package:duration/duration.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/home/view_models/study_session_vm.dart';
import 'package:study_timer/features/stats/heat_map_screen.dart';
import 'package:study_timer/features/themes/utils/colors.dart';
import 'package:fl_chart/fl_chart.dart';

class StudyLineChart extends ConsumerStatefulWidget {
  const StudyLineChart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyLineChartState();
}

class _StudyLineChartState extends ConsumerState<StudyLineChart> {
  List<StudySessionModel> studySessionsOfTheWeek() {
    List<StudySessionModel> studySessions = ref.watch(studySessionProvider);
    DateTime today = onlyDate(DateTime.now());
    DateTime firstDateOfTheWeek =
        today.subtract(Duration(days: today.weekday - 1));
    DateTime lastDateOfTheWeek =
        today.add(Duration(days: DateTime.daysPerWeek - today.weekday));
    return studySessions
        .where((element) =>
            (element.date.isAfter(firstDateOfTheWeek) ||
                element.date.isAtSameMomentAs(firstDateOfTheWeek)) &&
            (element.date.isBefore(lastDateOfTheWeek) ||
                element.date.isAtSameMomentAs(lastDateOfTheWeek)))
        .toList();
  }

  Duration getWeeklyStudyTime() {
    final thisWeek = studySessionsOfTheWeek();
    Duration studyTimeOfTheWeek = Duration.zero;
    for (StudySessionModel element in thisWeek) {
      studyTimeOfTheWeek += element.duration;
    }
    return studyTimeOfTheWeek;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: getStatsBoxColor(ref)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                Text(
                  prettyDuration(
                    getWeeklyStudyTime(),
                    tersity: DurationTersity.minute,
                    upperTersity: DurationTersity.hour,
                  ),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w700),
                ),
                const Gap(2),
                const Opacity(
                  opacity: 0.7,
                  child: Text(
                    "This week",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
                const Gap(10),
              ],
            ),
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 10,
                borderData: FlBorderData(
                  show: false,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 5),
                      const FlSpot(3, 1.5),
                      const FlSpot(4, 5.5),
                      const FlSpot(5, 3),
                      const FlSpot(6, 2.5),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
