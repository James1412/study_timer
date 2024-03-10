import 'package:hive/hive.dart';
import 'package:study_timer/utils/hive_box_const.dart';

final _box = Hive.box(firstTimeHiveBoxConst);

class FirstTimeRepository {
  bool get isFirstTime => _box.get(firstTimeHiveBoxConst) ?? true;

  void setIsFirstTime(bool val) {
    _box.put(firstTimeHiveBoxConst, val);
  }
}
