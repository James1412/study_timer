import 'package:flutter/material.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';

class StudySessionViewModel extends ChangeNotifier {
  int firstKey = UniqueKey().hashCode;
  int secondKey = UniqueKey().hashCode;
  int thirdKey = UniqueKey().hashCode;
  int fourthKey = UniqueKey().hashCode;
  int fifthKey = UniqueKey().hashCode;
  late List<StudySessionModel> studySessions = [
    StudySessionModel(
      subjectName: 'history',
      date: onlyDate(DateTime.now()).subtract(const Duration(days: 2)),
      duration: const Duration(hours: 2, minutes: 20),
      uniqueKey: firstKey,
      icon: null,
    ),
    StudySessionModel(
      subjectName: 'math',
      date: onlyDate(DateTime.now()).subtract(const Duration(days: 1)),
      duration: const Duration(hours: 2, minutes: 34, seconds: 29),
      uniqueKey: secondKey,
      icon: null,
    ),
    StudySessionModel(
      subjectName: 'science',
      date: onlyDate(DateTime.now()),
      duration: const Duration(hours: 1, minutes: 53),
      uniqueKey: thirdKey,
      icon: null,
    ),
    StudySessionModel(
      subjectName: 'science1',
      date: onlyDate(DateTime.now()),
      duration: const Duration(hours: 1),
      uniqueKey: fourthKey,
      icon: null,
    ),
    StudySessionModel(
      subjectName: 'science2',
      date: onlyDate(DateTime.now()).subtract(const Duration(days: 3)),
      duration: const Duration(hours: 1),
      uniqueKey: fifthKey,
      icon: null,
    ),
  ]..sort((a, b) => a.date.compareTo(b.date));

  late List<DateTime> studyDates =
      studySessions.map((e) => e.date).toSet().toList();

  void deleteStudySession(StudySessionModel studyTimeModel) {
    studySessions.removeWhere(
        (element) => element.uniqueKey == studyTimeModel.uniqueKey);
    studyDates = studySessions.map((e) => e.date).toSet().toList();
    notifyListeners();
  }

  void editStudySession(StudySessionModel studySessionModel) {
    IconData? subjectIcon = studySessions
            .lastWhere((element) =>
                element.subjectName == studySessionModel.subjectName)
            .icon ??
        studySessions
            .firstWhere((element) =>
                element.subjectName == studySessionModel.subjectName)
            .icon;

    for (StudySessionModel element in studySessions) {
      if (element.uniqueKey == studySessionModel.uniqueKey) {
        element.icon = subjectIcon;
        element.subjectName = studySessionModel.subjectName;
      }
    }
    notifyListeners();
  }

  void editSubjectIcon(StudySessionModel studySessionModel) {
    for (StudySessionModel element in studySessions) {
      if (element.subjectName == studySessionModel.subjectName) {
        element.icon = studySessionModel.icon;
      }
    }
    notifyListeners();
  }

  void addStudySession(StudySessionModel studyTimeModel) {
    studySessions.add(studyTimeModel);
    studyDates = studySessions.map((e) => e.date).toSet().toList();
    notifyListeners();
  }
}
