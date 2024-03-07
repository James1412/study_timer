import 'package:hive/hive.dart';
import 'package:study_timer/utils/hive_box_const.dart';

final _box = Hive.box(autoBrightnessHiveBoxConst);

class AutoBrightnessRepository {
  bool? get getAutoBrightness => _box.get(autoBrightnessHiveBoxConst);

  void setAutoBrightness(bool val) {
    _box.put(autoBrightnessHiveBoxConst, val);
  }
}
