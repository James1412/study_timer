import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';

class StudySessionViewModel extends Notifier<List<StudySessionModel>> {
  void deleteStudySession(StudySessionModel studyTimeModel) {
    final newState = [...state];
    newState.removeWhere(
        (element) => element.uniqueKey == studyTimeModel.uniqueKey);
    state = newState;
  }

  void editStudySession(StudySessionModel studySessionModel) {
    final newState = [...state];
    studySessionModel.icon = newState
            .firstWhere((element) =>
                element.subjectName == studySessionModel.subjectName)
            .icon ??
        newState
            .lastWhere((element) =>
                element.subjectName == studySessionModel.subjectName)
            .icon;
    for (StudySessionModel element in newState) {
      if (element.uniqueKey == studySessionModel.uniqueKey) {
        element.subjectName = studySessionModel.subjectName;
        element.icon = studySessionModel.icon;
      }
    }
    state = newState;
  }

  void editSubjectIcon(StudySessionModel studySessionModel) {
    final newState = [...state];
    for (StudySessionModel element in newState) {
      if (element.subjectName == studySessionModel.subjectName) {
        element.icon = studySessionModel.icon;
      }
    }
    state = newState;
  }

  void addStudySession(StudySessionModel studyTimeModel) {
    final List<StudySessionModel> newState = [...state];
    if (newState
        .where((element) => element.subjectName == studyTimeModel.subjectName)
        .isNotEmpty) {
      studyTimeModel.icon = newState
          .firstWhere(
              (element) => element.subjectName == studyTimeModel.subjectName)
          .icon;
    }
    newState.add(studyTimeModel);
    state = newState;
  }

  @override
  List<StudySessionModel> build() {
    int firstKey = UniqueKey().hashCode;
    int secondKey = UniqueKey().hashCode;
    int thirdKey = UniqueKey().hashCode;
    int fourthKey = UniqueKey().hashCode;
    int fifthKey = UniqueKey().hashCode;
    List<StudySessionModel> studySessions = [
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
        duration: const Duration(hours: 5, minutes: 34, seconds: 29),
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
        duration: const Duration(hours: 3),
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
    return studySessions;
  }
}

class StudyDatesViewModel extends Notifier<List<DateTime>> {
  @override
  List<DateTime> build() {
    late List<DateTime> studyDates =
        ref.watch(studySessionProvider).map((e) => e.date).toSet().toList();
    return studyDates;
  }
}

final studySessionProvider =
    NotifierProvider<StudySessionViewModel, List<StudySessionModel>>(
        () => StudySessionViewModel());
final studyDatesProvider =
    NotifierProvider<StudyDatesViewModel, List<DateTime>>(
        () => StudyDatesViewModel());
