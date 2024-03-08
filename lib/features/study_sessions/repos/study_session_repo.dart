import 'package:hive/hive.dart';
import 'package:study_timer/features/study_sessions/models/study_session_model.dart';
import 'package:study_timer/utils/hive_box_const.dart';

final _box = Hive.box<StudySessionModel>(studySessionsHiveBoxConst);

class StudySessionRepository {
  void addStudySession(StudySessionModel session) {
    _box.put(session.uniqueKey, session);
  }

  List<StudySessionModel> getStudySessions() {
    return _box.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  void deleteStudySession(StudySessionModel session) {
    _box.delete(session.uniqueKey);
  }

  void deleteAll() {
    _box.deleteAll(_box.keys);
  }
}
