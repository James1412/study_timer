import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/study_sessions/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/study_sessions/view_models/study_session_vm.dart';
import 'package:study_timer/features/stats/view_models/week_date_vm.dart';

bool isInTheWeek(WidgetRef ref, DateTime date, [DateTime? specificWeekDate]) {
  final weekDate = ref.watch(weekDateProvider);
  date = onlyDate(date);
  DateTime weekStart;
  DateTime weekEnd;
  if (specificWeekDate == null) {
    weekStart =
        onlyDate(weekDate.subtract(Duration(days: weekDate.weekday - 1)));
    weekEnd = onlyDate(
        weekDate.add(Duration(days: DateTime.daysPerWeek - weekDate.weekday)));
  } else {
    weekStart = onlyDate(specificWeekDate
        .subtract(Duration(days: specificWeekDate.weekday - 1)));
    weekEnd = onlyDate(specificWeekDate
        .add(Duration(days: DateTime.daysPerWeek - specificWeekDate.weekday)));
  }
  return ((date.isAfter(weekStart) || date.isAtSameMomentAs(weekStart)) &&
          date.isBefore(weekEnd) ||
      date.isAtSameMomentAs(weekEnd));
}

List<StudySessionModel> studySessionsOfTheWeek(WidgetRef ref,
    [DateTime? specificWeek]) {
  List<StudySessionModel> studySessions = ref.watch(studySessionProvider);
  if (specificWeek == null) {
    return studySessions
        .where((session) => isInTheWeek(ref, session.date))
        .toList();
  }
  return studySessions
      .where((session) => isInTheWeek(ref, session.date, specificWeek))
      .toList();
}

List<StudySessionModel> studySessionsOfTheDay(WidgetRef ref, DateTime date) {
  final allSessions = ref.watch(studySessionProvider);
  return allSessions
      .where(
          (element) => onlyDate(element.date).isAtSameMomentAs(onlyDate(date)))
      .toList();
}

Duration getWeeklyTotalStudyTime(WidgetRef ref, [DateTime? specificWeek]) {
  List<StudySessionModel> thisWeek;
  if (specificWeek == null) {
    thisWeek = studySessionsOfTheWeek(ref);
  } else {
    thisWeek = studySessionsOfTheWeek(ref, specificWeek);
  }
  Duration studyTimeOfTheWeek = Duration.zero;
  for (StudySessionModel element in thisWeek) {
    studyTimeOfTheWeek += element.duration;
  }
  return studyTimeOfTheWeek;
}

double avgStudyHourPerDay(WidgetRef ref, [DateTime? specificWeek]) {
  Duration totalTime;
  int numOfDays = 7;
  if (specificWeek == null) {
    totalTime = getWeeklyTotalStudyTime(ref);
  } else {
    totalTime = getWeeklyTotalStudyTime(ref, specificWeek);
  }
  if (numOfDays == 0) {
    return 0;
  }
  return double.parse(
      ((totalTime.inMinutes / numOfDays) / 60).toStringAsFixed(2));
}

String avgStudyHourPerDayPercentChange(WidgetRef ref) {
  final currentWeek = avgStudyHourPerDay(ref);
  final prevWeek = avgStudyHourPerDay(
      ref, ref.watch(weekDateProvider).subtract(const Duration(days: 7)));
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

String percentChangeStudySessionsOfTheWeek(WidgetRef ref) {
  final currentWeek = studySessionsOfTheWeek(ref).length;
  final prevWeek = studySessionsOfTheWeek(
          ref, ref.watch(weekDateProvider).subtract(const Duration(days: 7)))
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

String findTopSubjectOfTheWeek(WidgetRef ref) {
  Map<String, int> subjectTotalDuration = {};
  for (StudySessionModel session in studySessionsOfTheWeek(ref)) {
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

int findLongestStudyStreak(WidgetRef ref) {
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

Map<String, Duration> weeklySubjectDurationMap(WidgetRef ref) {
  Map<String, Duration> subjectDurationMap = {};

  for (StudySessionModel session in studySessionsOfTheWeek(ref)) {
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

double maxDurationOfTheWeek(WidgetRef ref, [DateTime? specificWeek]) {
  List<StudySessionModel> sessions;
  if (specificWeek == null) {
    sessions = studySessionsOfTheWeek(ref);
  } else {
    sessions = studySessionsOfTheWeek(ref, specificWeek);
  }
  sessions.sort((a, b) => a.duration.compareTo(b.duration));
  double maxHour = 0;
  if (sessions.isNotEmpty) {
    maxHour = sessions.last.duration.inMinutes / 60;
  }
  return double.parse(maxHour.toStringAsFixed(1));
}

double totalStudyTimeComparedToPreviousWeek(WidgetRef ref) {
  final currentWeekStudyTime = getWeeklyTotalStudyTime(ref).inMinutes;
  final weekDate = ref.watch(weekDateProvider);
  final prevWeekStudyTime =
      getWeeklyTotalStudyTime(ref, weekDate.subtract(const Duration(days: 7)))
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
