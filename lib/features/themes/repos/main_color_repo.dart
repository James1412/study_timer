import 'package:hive/hive.dart';
import 'package:study_timer/features/themes/models/main_color_model.dart';
import 'package:study_timer/utils/hive_box_const.dart';

final _box = Hive.box<MainColors>(mainColorHiveBoxConst);

class MainColorRepository {
  MainColors? get getMainColor => _box.get(mainColorHiveBoxConst);

  void setMainColor(MainColors color) {
    _box.put(mainColorHiveBoxConst, color);
  }
}
