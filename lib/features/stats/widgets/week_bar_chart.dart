import 'package:duration/duration.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:study_timer/features/study_sessions/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';

import 'package:study_timer/features/settings/view_models/show_percent_change_vm.dart';
import 'package:study_timer/features/stats/functions/stats_calculation.dart';
import 'package:study_timer/features/stats/heat_map_screen.dart';
import 'package:study_timer/features/stats/view_models/week_date_vm.dart';
import 'package:study_timer/features/themes/utils/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:study_timer/features/themes/view_models/main_color_vm.dart';
import 'package:study_timer/utils/ios_haptic.dart';

class WeekBarChart extends ConsumerStatefulWidget {
  const WeekBarChart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeekBarChartState();
}

class _WeekBarChartState extends ConsumerState<WeekBarChart> {
  List<IndividualBar> barData() {
    List<IndividualBar> data = [];
    final studySessions = studySessionsOfTheWeek(ref);
    final weekDate = ref.watch(weekDateProvider);
    DateTime firstDateOfTheWeek =
        weekDate.subtract(Duration(days: weekDate.weekday - 1));
    for (int i = 0; i < 7; i++) {
      DateTime currentDate = firstDateOfTheWeek.add(Duration(days: i));
      double totalStudyTime = 0;
      for (StudySessionModel session in studySessions) {
        if (onlyDate(session.date) == currentDate) {
          totalStudyTime += session.duration.inMinutes.toDouble();
        }
      }
      data.add(IndividualBar(
          x: i, y: double.parse((totalStudyTime / 60).toStringAsFixed(1))));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    DateTime weekDate = ref.watch(weekDateProvider);
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
                    iosLightFeedback();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HeatMapCalendarScreen()),
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
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
                ),
                // Total Duration
                Text(
                  prettyDuration(
                    getWeeklyTotalStudyTime(ref),
                    tersity: DurationTersity.minute,
                    upperTersity: DurationTersity.hour,
                  ),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w700),
                ),
                const Gap(5),
                // Percentage Change
                if (ref.watch(showPercentChangeProvider))
                  Text(
                    totalStudyTimeComparedToPreviousWeekPercentage(ref) > 0
                        ? "+${totalStudyTimeComparedToPreviousWeekPercentage(ref)}%"
                        : "${totalStudyTimeComparedToPreviousWeekPercentage(ref)}%",
                    style: TextStyle(
                        color: totalStudyTimeComparedToPreviousWeekPercentage(
                                    ref) >
                                0
                            ? Colors.green
                            : totalStudyTimeComparedToPreviousWeekPercentage(
                                        ref) ==
                                    0
                                ? Colors.grey
                                : Colors.red),
                  ),
              ],
            ),
          ),
          const Gap(25),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY:
                    maxDurationOfTheWeek(ref) + maxDurationOfTheWeek(ref) / 2.5,
                minY: 0,
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(
                  show: true,
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 38,
                      showTitles: true,
                      getTitlesWidget: getBottomTitles,
                    ),
                  ),
                ),
                barGroups: barData()
                    .map(
                      (data) => BarChartGroupData(
                        x: data.x,
                        barRods: [
                          BarChartRodData(
                              toY: data.y,
                              width: 25,
                              borderRadius: BorderRadius.circular(4),
                              color: ref.watch(mainColorProvider)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    iosLightFeedback();
                    ref.read(weekDateProvider.notifier).changeWeekDate(
                        weekDate.subtract(const Duration(days: 7)));
                  },
                  child: Container(
                      color: Colors.transparent,
                      child: const Icon(FluentIcons.chevron_left_12_filled)),
                ),
              ),
              Container(
                color: Colors.transparent,
                width: 180,
                child: Center(
                    child: Text(
                  isInTheWeek(ref, weekDate, onlyDate(DateTime.now().toUtc()))
                      ? "This week"
                      : isInTheWeek(
                              ref,
                              weekDate,
                              onlyDate(DateTime.now()
                                  .subtract(const Duration(days: 7))))
                          ? "Last week"
                          : "Week of ${DateFormat.yMd().format(weekDate)}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w400),
                )),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    iosLightFeedback();
                    if (!isInTheWeek(ref, onlyDate(DateTime.now().toUtc()))) {
                      ref.read(weekDateProvider.notifier).changeWeekDate(
                            weekDate.add(const Duration(days: 7)),
                          );
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Opacity(
                        opacity:
                            isInTheWeek(ref, onlyDate(DateTime.now().toUtc()))
                                ? 0.3
                                : 1,
                        child: const Icon(FluentIcons.chevron_right_12_filled)),
                  ),
                ),
              ),
            ],
          ),
          const Gap(10),
        ],
      ),
    );
  }
}

class IndividualBar {
  final int x;
  final double y;

  IndividualBar({required this.x, required this.y});
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text("M", style: style);
    case 1:
      text = const Text("T", style: style);
    case 2:
      text = const Text("W", style: style);
    case 3:
      text = const Text("T", style: style);
    case 4:
      text = const Text("F", style: style);
    case 5:
      text = const Text("S", style: style);
    default:
      text = const Text("S", style: style);
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
