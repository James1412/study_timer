import 'package:flutter/material.dart';
import 'package:study_timer/features/home/models/date_model.dart';
import 'package:study_timer/features/home/models/study_time_model.dart';
import 'package:study_timer/features/home/utils.dart';

class StudyDateViewModel extends ChangeNotifier {
  int firstKey = UniqueKey().hashCode;
  int secondKey = UniqueKey().hashCode;
  int thirdKey = UniqueKey().hashCode;
  late List<DateModel> studyDates = [
    DateModel(studyTimes: [
      StudyTimeModel(
        subjectName: 'history',
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        duration: const Duration(hours: 2),
        uniqueKey: firstKey,
      ),
    ], date: DateTime.now().subtract(const Duration(days: 2))),
    DateModel(
        studyTimes: [], date: DateTime.now().subtract(const Duration(days: 1))),
    DateModel(studyTimes: [
      StudyTimeModel(
        subjectName: 'math',
        dateTime: DateTime.now(),
        duration: const Duration(hours: 2, minutes: 34, seconds: 29),
        uniqueKey: secondKey,
      ),
      StudyTimeModel(
        subjectName: 'science',
        dateTime: DateTime.now(),
        duration: const Duration(hours: 1),
        uniqueKey: thirdKey,
      ),
    ], date: DateTime.now()),
  ];

  void deleteStudyTimeModel(StudyTimeModel studyTimeModel) {
    for (DateModel studyDate in studyDates) {
      if (isSameDate(studyDate.date, studyTimeModel.dateTime)) {
        studyDate.studyTimes.removeWhere(
            (element) => element.uniqueKey == studyTimeModel.uniqueKey);
      }
    }
    studyDates.removeWhere((date) => date.studyTimes.isEmpty);
    notifyListeners();
  }

  void editStudyTimeModel(StudyTimeModel studyTimeModel) {
    for (DateModel studyDate in studyDates) {
      if (isSameDate(studyDate.date, studyTimeModel.dateTime)) {
        studyDate.studyTimes.map((element) {
          if (element.uniqueKey == studyTimeModel.uniqueKey) {
            return element = studyTimeModel;
          }
        });
      }
    }
    notifyListeners();
  }

  void addStudyTimeModel(StudyTimeModel studyTimeModel) {
    for (DateModel studyDate in studyDates) {
      if (isSameDate(studyDate.date, studyTimeModel.dateTime)) {
        studyDate.studyTimes.add(studyTimeModel);
        notifyListeners();
        return;
      }
    }
    studyDates.add(
      DateModel(
          studyTimes: [studyTimeModel],
          date: onlyDate(studyTimeModel.dateTime)),
    );
    notifyListeners();
  }
}
