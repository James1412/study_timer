import 'package:flutter/material.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';

class StudySessionViewModel extends ChangeNotifier {
  int firstKey = UniqueKey().hashCode;
  int secondKey = UniqueKey().hashCode;
  int thirdKey = UniqueKey().hashCode;
  int fourthKey = UniqueKey().hashCode;
  late List<StudySessionModel> studySessions = [
    StudySessionModel(
      subjectName: 'history',
      dateTime: onlyDate(DateTime.now()).subtract(const Duration(days: 2)),
      duration: const Duration(hours: 2),
      uniqueKey: firstKey,
    ),
    StudySessionModel(
      subjectName: 'math',
      dateTime: onlyDate(DateTime.now()).subtract(const Duration(days: 1)),
      duration: const Duration(hours: 2, minutes: 34, seconds: 29),
      uniqueKey: secondKey,
    ),
    StudySessionModel(
      subjectName: 'science',
      dateTime: onlyDate(DateTime.now()),
      duration: const Duration(hours: 1),
      uniqueKey: thirdKey,
    ),
    StudySessionModel(
      subjectName: 'science1',
      dateTime: onlyDate(DateTime.now()),
      duration: const Duration(hours: 1),
      uniqueKey: fourthKey,
    ),
  ];

  late List<DateTime> studyDates =
      studySessions.map((e) => e.dateTime).toSet().toList();

  void deleteStudySession(StudySessionModel studyTimeModel) {
    studySessions.removeWhere(
        (element) => element.uniqueKey == studyTimeModel.uniqueKey);
    studyDates = studySessions.map((e) => e.dateTime).toSet().toList();
    notifyListeners();
  }

  void editStudySession(StudySessionModel studyTimeModel) {
    studySessions.map((element) {
      if (element.uniqueKey == studyTimeModel.uniqueKey) {
        return element = studyTimeModel;
      }
    });
    notifyListeners();
  }

  void addStudySession(StudySessionModel studyTimeModel) {
    studySessions.add(studyTimeModel);
    notifyListeners();
    return;
  }
}
