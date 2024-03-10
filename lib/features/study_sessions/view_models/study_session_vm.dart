import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:study_timer/features/study_sessions/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/study_sessions/repos/study_session_repo.dart';
import 'package:study_timer/utils/hive_box_const.dart';

class StudySessionViewModel extends Notifier<List<StudySessionModel>> {
  final StudySessionRepository _repository = StudySessionRepository();

  void deleteStudySession(StudySessionModel session) {
    final newState = [...state];
    newState.removeWhere((element) => element.uniqueKey == session.uniqueKey);
    _repository.deleteStudySession(session);
    state = _repository.getStudySessions();
  }

  void editStudySession(StudySessionModel session) {
    final newState = [...state];
    session.iconData = newState
        .firstWhere((element) => element.subjectName == session.subjectName)
        .iconData;
    for (StudySessionModel element in newState) {
      if (element.uniqueKey == session.uniqueKey) {
        element.subjectName = session.subjectName;
        element.iconData = session.iconData;
      }
    }
    for (StudySessionModel session in newState) {
      _repository.addStudySession(session);
    }
    state = _repository.getStudySessions();
  }

  void editSubjectIcon(StudySessionModel session) {
    final newState = [...state];
    for (StudySessionModel element in newState) {
      if (element.subjectName == session.subjectName) {
        element.iconData = session.iconData;
      }
    }
    for (StudySessionModel session in newState) {
      _repository.addStudySession(session);
    }
    state = _repository.getStudySessions();
  }

  void addStudySession(StudySessionModel session) {
    final List<StudySessionModel> newState = [...state];
    if (newState
        .where((element) => element.subjectName == session.subjectName)
        .isNotEmpty) {
      session.iconData = newState
          .firstWhere((element) => element.subjectName == session.subjectName)
          .iconData;
    }
    newState.add(session);
    for (StudySessionModel session in newState) {
      _repository.addStudySession(session);
    }
    state = _repository.getStudySessions();
  }

  @override
  List<StudySessionModel> build() {
    List<StudySessionModel> studySessions = [
      StudySessionModel(
        subjectName: 'history',
        date: onlyDate(DateTime.now()).subtract(const Duration(days: 2)),
        duration: const Duration(hours: 2, minutes: 20),
        uniqueKey: 5,
        iconData: [
          CupertinoIcons.book.codePoint,
          CupertinoIcons.book.fontFamily,
          CupertinoIcons.book.fontPackage,
        ],
      ),
      StudySessionModel(
        subjectName: 'math',
        date: onlyDate(DateTime.now()).subtract(const Duration(days: 1)),
        duration: const Duration(hours: 5, minutes: 34, seconds: 29),
        uniqueKey: 4,
        iconData: [
          CupertinoIcons.book.codePoint,
          CupertinoIcons.book.fontFamily,
          CupertinoIcons.book.fontPackage,
        ],
      ),
      StudySessionModel(
        subjectName: 'art',
        date: onlyDate(DateTime.now()),
        duration: const Duration(hours: 1, minutes: 53),
        uniqueKey: 3,
        iconData: [
          CupertinoIcons.book.codePoint,
          CupertinoIcons.book.fontFamily,
          CupertinoIcons.book.fontPackage,
        ],
      ),
      StudySessionModel(
        subjectName: 'science',
        date: onlyDate(DateTime.now()),
        duration: const Duration(hours: 3),
        uniqueKey: 2,
        iconData: [
          CupertinoIcons.book.codePoint,
          CupertinoIcons.book.fontFamily,
          CupertinoIcons.book.fontPackage,
        ],
      ),
      StudySessionModel(
        subjectName: 'english',
        date: onlyDate(DateTime.now()).subtract(const Duration(days: 3)),
        duration: const Duration(hours: 1),
        uniqueKey: 1,
        iconData: [
          CupertinoIcons.book.codePoint,
          CupertinoIcons.book.fontFamily,
          CupertinoIcons.book.fontPackage,
        ],
      ),
      StudySessionModel(
        subjectName: 'statistics',
        date: DateTime(2024, 3, 3),
        duration: const Duration(hours: 0, minutes: 30),
        uniqueKey: 0,
        iconData: [
          CupertinoIcons.book.codePoint,
          CupertinoIcons.book.fontFamily,
          CupertinoIcons.book.fontPackage
        ],
      ),
    ]..sort((a, b) => a.date.compareTo(b.date));

    final firstBox = Hive.box(firstTimeHiveBoxConst);
    if (firstBox.get(firstTimeHiveBoxConst) == null) {
      firstBox.put(firstTimeHiveBoxConst, true);
    }
    if (firstBox.get(firstTimeHiveBoxConst) == null) {
      for (StudySessionModel session in studySessions) {
        _repository.addStudySession(session);
      }
    }

    return _repository.getStudySessions();
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
