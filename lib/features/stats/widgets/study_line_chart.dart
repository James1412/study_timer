import 'package:duration/duration.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/home/view_models/study_session_vm.dart';
import 'package:study_timer/features/stats/heat_map_screen.dart';
import 'package:study_timer/features/themes/utils/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:study_timer/features/themes/view_models/main_color_vm.dart';

class StudyLineChart extends ConsumerStatefulWidget {
  const StudyLineChart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyLineChartState();
}

class _StudyLineChartState extends ConsumerState<StudyLineChart> {
  bool isInTheWeekOf(DateTime date) {
    date = onlyDate(date);
    DateTime firstDateOfTheWeek =
        onlyDate(date.subtract(Duration(days: weekDate.weekday - 1)));
    DateTime lastDateOfTheWeek = onlyDate(
        date.add(Duration(days: DateTime.daysPerWeek - weekDate.weekday)));
    if ((weekDate.isAfter(firstDateOfTheWeek) ||
                weekDate.isAtSameMomentAs(firstDateOfTheWeek)) &&
            weekDate.isBefore(lastDateOfTheWeek) ||
        weekDate.isAtSameMomentAs(lastDateOfTheWeek)) {
      return true;
    }
    return false;
  }

  List<StudySessionModel> studySessionsOfTheWeek() {
    List<StudySessionModel> studySessions = ref.watch(studySessionProvider);
    return studySessions.where((element) => isInTheWeekOf(weekDate)).toList();
  }

  Duration getWeeklyTotalStudyTime() {
    final thisWeek = studySessionsOfTheWeek();
    Duration studyTimeOfTheWeek = Duration.zero;
    for (StudySessionModel element in thisWeek) {
      studyTimeOfTheWeek += element.duration;
    }
    return studyTimeOfTheWeek;
  }

  double maxDurationOfTheWeek() {
    List<StudySessionModel> sessions = studySessionsOfTheWeek();
    sessions.sort((a, b) => a.duration.compareTo(b.duration));
    double maxHour = 0;
    if (sessions.isNotEmpty) {
      maxHour = sessions.last.duration.inMinutes / 60;
    }
    return maxHour;
  }

  List<IndividualBar> barData() {
    List<IndividualBar> data = [];
    final studySessions = studySessionsOfTheWeek();
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

  DateTime weekDate = onlyDate(DateTime.now());

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
                    getWeeklyTotalStudyTime(),
                    tersity: DurationTersity.minute,
                    upperTersity: DurationTersity.hour,
                  ),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w700),
                ),
                const Gap(2),
                Opacity(
                  opacity: 0.7,
                  child: Text(
                    isInTheWeekOf(DateTime.now())
                        ? "This week"
                        : isInTheWeekOf(DateTime.now()
                                .subtract(const Duration(days: 7)))
                            ? "Last week"
                            : "Week of ${DateFormat.yMMMMd().format(weekDate)}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
                const Gap(10),
              ],
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: maxDurationOfTheWeek() + 1,
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
                      weekDate = weekDate.subtract(const Duration(days: 7));
                      setState(() {});
                    },
                    child: const Icon(FluentIcons.chevron_left_12_filled)),
              ),
              SizedBox(
                width: 180,
                child:
                    Center(child: Text(DateFormat.yMMMMd().format(weekDate))),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!isInTheWeekOf(DateTime.now())) {
                      weekDate = weekDate.add(const Duration(days: 7));
                    }
                    setState(() {});
                  },
                  child: Opacity(
                      opacity: isInTheWeekOf(DateTime.now()) ? 0.5 : 1,
                      child: const Icon(FluentIcons.chevron_right_12_filled)),
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