import 'package:hive/hive.dart';
part 'study_session_model.g.dart';

@HiveType(typeId: 1)
class StudySessionModel {
  @HiveField(0)
  String subjectName;

  @HiveField(1)
  Duration duration;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  int uniqueKey;

  @HiveField(4)
  List<dynamic> iconData;

  StudySessionModel({
    required this.subjectName,
    required this.date,
    required this.duration,
    required this.uniqueKey,
    required this.iconData,
  });
}
