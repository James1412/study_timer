import 'package:duration/duration.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/settings/view_models/show_percent_change_vm.dart';
import 'package:study_timer/features/stats/heat_map_screen.dart';
import 'package:study_timer/features/stats/view_models/week_date_vm.dart';
import 'package:study_timer/features/themes/utils/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:study_timer/features/themes/view_models/main_color_vm.dart';
import 'package:study_timer/utils/ios_haptic.dart';

class StudyLineChart extends ConsumerStatefulWidget {
  final Function isInTheWeek;
  final Function studySessionsOfTheWeek;
  final Function getWeeklyTotalStudyTime;
  const StudyLineChart(
      {required this.isInTheWeek,
      required this.studySessionsOfTheWeek,
      required this.getWeeklyTotalStudyTime,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyLineChartState();
}

class _StudyLineChartState extends ConsumerState<StudyLineChart> {
  double maxDurationOfTheWeek([DateTime? specificWeek]) {
    List<StudySessionModel> sessions;
    if (specificWeek == null) {
      sessions = widget.studySessionsOfTheWeek();
    } else {
      sessions = widget.studySessionsOfTheWeek(specificWeek);
    }
    sessions.sort((a, b) => a.duration.compareTo(b.duration));
    double maxHour = 0;
    if (sessions.isNotEmpty) {
      maxHour = sessions.last.duration.inMinutes / 60;
    }
    return double.parse(maxHour.toStringAsFixed(1));
  }

  double totalStudyTimeComparedToPreviousWeek() {
    final currentWeekStudyTime = widget.getWeeklyTotalStudyTime().inMinutes;
    final prevWeekStudyTime = widget
        .getWeeklyTotalStudyTime(weekDate.subtract(const Duration(days: 7)))
        .inMinutes;
    double percentage = 0;
    if (prevWeekStudyTime == 0.0 && currentWeekStudyTime == 0.0) {
      percentage = 0.0;
    } else if (prevWeekStudyTime == 0) {
      percentage = 100.0;
    } else {
      percentage =
          (currentWeekStudyTime - prevWeekStudyTime) / prevWeekStudyTime * 100;
    }
    return double.parse(percentage.toStringAsFixed(1));
  }

  List<IndividualBar> barData() {
    List<IndividualBar> data = [];
    final studySessions = widget.studySessionsOfTheWeek();
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

  late DateTime weekDate = ref.watch(weekDateProvider);

  @override
  Widget build(BuildContext context) {
    weekDate = ref.watch(weekDateProvider);
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
                // Total Duration
                Text(
                  prettyDuration(
                    widget.getWeeklyTotalStudyTime(),
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
                    totalStudyTimeComparedToPreviousWeek() > 0
                        ? "+${totalStudyTimeComparedToPreviousWeek()}%"
                        : "${totalStudyTimeComparedToPreviousWeek()}%",
                    style: TextStyle(
                        color: totalStudyTimeComparedToPreviousWeek() > 0
                            ? Colors.green
                            : totalStudyTimeComparedToPreviousWeek() == 0
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
                maxY: maxDurationOfTheWeek() + maxDurationOfTheWeek() / 2.5,
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
                  widget.isInTheWeek(weekDate, DateTime.now())
                      ? "This week"
                      : widget.isInTheWeek(weekDate,
                              DateTime.now().subtract(const Duration(days: 7)))
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
                    if (!widget.isInTheWeek(DateTime.now())) {
                      ref.read(weekDateProvider.notifier).changeWeekDate(
                          weekDate.add(const Duration(days: 7)));
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Opacity(
                        opacity: widget.isInTheWeek(DateTime.now()) ? 0.3 : 1,
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
