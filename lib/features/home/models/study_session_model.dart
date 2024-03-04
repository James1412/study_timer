import 'package:flutter/material.dart';

class StudySessionModel {
  String subjectName;
  Duration duration;
  DateTime dateTime;
  int uniqueKey;
  IconData? icon;

  StudySessionModel({
    required this.subjectName,
    required this.dateTime,
    required this.duration,
    required this.uniqueKey,
    required this.icon,
  });
}
