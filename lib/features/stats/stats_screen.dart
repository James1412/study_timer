import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/home/view_models/study_session_vm.dart';
import 'package:study_timer/features/settings/settings_screen.dart';
import 'package:study_timer/features/stats/view_models/week_date_vm.dart';
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
  bool isInTheWeek(DateTime date, [DateTime? specificWeekDate]) {
    final weekDate = ref.watch(weekDateProvider);
    date = onlyDate(date);
    DateTime weekStart;
    DateTime weekEnd;
    if (specificWeekDate == null) {
      weekStart =
          onlyDate(weekDate.subtract(Duration(days: weekDate.weekday - 1)));
      weekEnd = onlyDate(weekDate
          .add(Duration(days: DateTime.daysPerWeek - weekDate.weekday)));
    } else {
      weekStart = onlyDate(specificWeekDate
          .subtract(Duration(days: specificWeekDate.weekday - 1)));
      weekEnd = onlyDate(specificWeekDate.add(
          Duration(days: DateTime.daysPerWeek - specificWeekDate.weekday)));
    }
    return ((date.isAfter(weekStart) || date.isAtSameMomentAs(weekStart)) &&
            date.isBefore(weekEnd) ||
        date.isAtSameMomentAs(weekEnd));
  }

  List<StudySessionModel> studySessionsOfTheWeek([DateTime? specificWeek]) {
    List<StudySessionModel> studySessions = ref.watch(studySessionProvider);
    if (specificWeek == null) {
      return studySessions
          .where((session) => isInTheWeek(session.date))
          .toList();
    }
    return studySessions
        .where((session) => isInTheWeek(session.date, specificWeek))
        .toList();
  }

  Duration getWeeklyTotalStudyTime([DateTime? specificWeek]) {
    List<StudySessionModel> thisWeek;
    if (specificWeek == null) {
      thisWeek = studySessionsOfTheWeek();
    } else {
      thisWeek = studySessionsOfTheWeek(specificWeek);
    }
    Duration studyTimeOfTheWeek = Duration.zero;
    for (StudySessionModel element in thisWeek) {
      studyTimeOfTheWeek += element.duration;
    }
    return studyTimeOfTheWeek;
  }

  double avgStudyHourPerDay([DateTime? specificWeek]) {
    Duration totalTime;
    int numOfDays = 7;
    if (specificWeek == null) {
      totalTime = getWeeklyTotalStudyTime();
    } else {
      totalTime = getWeeklyTotalStudyTime(specificWeek);
    }
    if (numOfDays == 0) {
      return 0;
    }
    return double.parse(
        ((totalTime.inMinutes / numOfDays) / 60).toStringAsFixed(2));
  }

  String avgStudyHourPerDayPercentChange() {
    final currentWeek = avgStudyHourPerDay();
    final prevWeek = avgStudyHourPerDay(
        ref.watch(weekDateProvider).subtract(const Duration(days: 7)));
    double percent = ((currentWeek - prevWeek) / prevWeek) * 100;
    if (prevWeek == 0 && currentWeek == 0) {
      percent = 0.0;
    } else if (prevWeek == 0) {
      percent = 100.0;
    }
    if (double.parse((percent.toStringAsFixed(1))) > 0) {
      return "+${double.parse((percent.toStringAsFixed(1)))}";
    } else {
      return "${double.parse((percent.toStringAsFixed(1)))}";
    }
  }

  String percentChangeStudySessionsOfTheWeek() {
    final currentWeek = studySessionsOfTheWeek().length;
    final prevWeek = studySessionsOfTheWeek(
            ref.watch(weekDateProvider).subtract(const Duration(days: 7)))
        .length;
    double percent = ((currentWeek - prevWeek) / prevWeek) * 100;
    if (prevWeek == 0 && currentWeek == 0) {
      percent = 0.0;
    } else if (prevWeek == 0) {
      percent = 100.0;
    }
    if (double.parse((percent.toStringAsFixed(1))) > 0) {
      return "+${double.parse((percent.toStringAsFixed(1)))}";
    } else {
      return "${double.parse((percent.toStringAsFixed(1)))}";
    }
  }

  String findTopSubjectOfTheWeek() {
    Map<String, int> subjectTotalDuration = {};
    for (StudySessionModel session in studySessionsOfTheWeek()) {
      String subject = session.subjectName;
      int durationInMinutes = session.duration.inMinutes;

      if (subjectTotalDuration.containsKey(subject)) {
        subjectTotalDuration[subject] =
            durationInMinutes + subjectTotalDuration[subject]!;
      } else {
        subjectTotalDuration[subject] = durationInMinutes;
      }
    }
    String? topSubject;
    int maxDuration = 0;
    subjectTotalDuration.forEach((subject, duration) {
      if (duration > maxDuration) {
        topSubject = subject;
        maxDuration = duration;
      }
    });

    return topSubject ?? "no data";
  }

  int findLongestStudyStreak() {
    List<StudySessionModel> studySessions = ref.watch(studySessionProvider);
    if (studySessions.isEmpty) {
      return 0;
    }
    studySessions.sort((a, b) => a.date.compareTo(b.date));

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < studySessions.length; i++) {
      if (studySessions[i].date.difference(studySessions[i - 1].date).inDays ==
          1) {
        currentStreak++;
      } else {
        currentStreak = 1;
      }
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }
    }

    return longestStreak;
  }

  Map<String, Duration> calculateSubjectDuration() {
    Map<String, Duration> subjectDurationMap = {};

    for (StudySessionModel session in studySessionsOfTheWeek()) {
      String subject = session.subjectName;
      if (!subjectDurationMap.containsKey(subject)) {
        subjectDurationMap[subject] = session.duration;
      } else {
        subjectDurationMap[subject] =
            session.duration + subjectDurationMap[subject]!;
      }
    }
    return subjectDurationMap;
  }

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
          StudyLineChart(
            getWeeklyTotalStudyTime: getWeeklyTotalStudyTime,
            isInTheWeek: isInTheWeek,
            studySessionsOfTheWeek: studySessionsOfTheWeek,
          ),
          const Gap(20),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1.25,
            children: [
              GridStatBox(
                title: 'Average study time per day',
                stat: "${avgStudyHourPerDay()}hr",
                change: '${avgStudyHourPerDayPercentChange()}%',
              ),
              GridStatBox(
                title: 'Study sessions of the week',
                stat: studySessionsOfTheWeek().length.toString(),
                change: '${percentChangeStudySessionsOfTheWeek()}%',
              ),
              GridStatBox(
                title: 'Top subject of the week',
                stat: findTopSubjectOfTheWeek(),
              ),
              GridStatBox(
                title: 'Longest study streak',
                stat: "${findLongestStudyStreak()} day",
              ),
            ],
          ),
          const Gap(16),
          SubjectStatBox(calculateSubjectDuration()),
        ],
      ),
    );
  }
}
