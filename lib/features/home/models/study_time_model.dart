class StudyTimeModel {
  String subjectName;
  Duration duration;
  DateTime dateTime;
  int uniqueKey;

  StudyTimeModel({
    required this.subjectName,
    required this.dateTime,
    required this.duration,
    required this.uniqueKey,
  });
}
