import 'package:flutter/material.dart';
import 'package:study_timer/features/home/models/date_model.dart';
import 'package:study_timer/features/home/models/study_time_model.dart';

class StudyDateViewModel extends ChangeNotifier {
  List<DateModel> dates = [
    DateModel(studyTimes: [
      StudyTimeModel(
          subjectName: 'math',
          dateTime: DateTime.now().subtract(const Duration(days: 2)),
          duration: const Duration(hours: 2)),
    ], date: DateTime.now().subtract(const Duration(days: 2))),
    DateModel(
        studyTimes: [], date: DateTime.now().subtract(const Duration(days: 1))),
    DateModel(studyTimes: [
      StudyTimeModel(
          subjectName: 'math',
          dateTime: DateTime.now().subtract(const Duration(days: 2)),
          duration: const Duration(hours: 2, minutes: 34, seconds: 29)),
      StudyTimeModel(
          subjectName: 'science',
          dateTime: DateTime.now().subtract(const Duration(days: 2)),
          duration: const Duration(hours: 1)),
    ], date: DateTime.now()),
  ];
}
