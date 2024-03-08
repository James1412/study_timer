import 'package:hive/hive.dart';
import 'package:study_timer/utils/hive_box_const.dart';

final _box = Hive.box(showPercentChangeHiveBoxConst);

class ShowPercentChangeRepository {
  bool? get getShowPercentChange => _box.get(showPercentChangeHiveBoxConst);

  void setShowPercentChange(bool val) {
    _box.put(showPercentChangeHiveBoxConst, val);
  }
}
