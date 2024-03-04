import 'package:flutter/material.dart';

class StudySessionModel {
  String subjectName;
  Duration duration;
  DateTime date;
  int uniqueKey;
  IconData? icon;

  StudySessionModel({
    required this.subjectName,
    required this.date,
    required this.duration,
    required this.uniqueKey,
    required this.icon,
  });
}
