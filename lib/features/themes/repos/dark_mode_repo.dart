import 'package:hive/hive.dart';
import 'package:study_timer/utils/hive_box_const.dart';

final _box = Hive.box(darkmodeHiveBoxConst);

class DarkModeRepository {
  bool? get getDarkmode => _box.get(darkmodeHiveBoxConst);

  void setDarkmode(bool val) {
    _box.put(darkmodeHiveBoxConst, val);
  }
}
