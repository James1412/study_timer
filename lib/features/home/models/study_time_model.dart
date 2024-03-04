class StudySessionModel {
  String subjectName;
  Duration duration;
  DateTime dateTime;
  int uniqueKey;

  StudySessionModel({
    required this.subjectName,
    required this.dateTime,
    required this.duration,
    required this.uniqueKey,
  });
}
