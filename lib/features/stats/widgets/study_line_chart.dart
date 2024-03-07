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
import 'package:study_timer/features/themes/view_models/main_color_vm.dart';

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

  double maxDurationOfTheWeek() {
    List<StudySessionModel> sessions = studySessionsOfTheWeek();
    sessions.sort((a, b) => a.duration.compareTo(b.duration));
    final maxHour = sessions.last.duration.inMinutes / 60;
    return maxHour;
  }

  @override
  Widget build(BuildContext context) {
    BarData weeklyBarData = BarData(
      monAmount: 5,
      tueAmount: 4,
      wedAmount: 2,
      thuAmount: 1,
      friAmount: 4.3,
      satAmount: 4.5,
      sunAmount: 5.5,
    );
    weeklyBarData.initializeBarData();
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
            child: BarChart(
              BarChartData(
                maxY: maxDurationOfTheWeek(),
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
                barGroups: weeklyBarData.barData
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

class BarData {
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;

  BarData({
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
    required this.sunAmount,
  });
  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: monAmount),
      IndividualBar(x: 1, y: tueAmount),
      IndividualBar(x: 2, y: wedAmount),
      IndividualBar(x: 3, y: thuAmount),
      IndividualBar(x: 4, y: friAmount),
      IndividualBar(x: 5, y: satAmount),
      IndividualBar(x: 6, y: sunAmount),
    ];
  }
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
