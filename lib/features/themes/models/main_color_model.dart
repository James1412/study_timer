import 'package:hive/hive.dart';
part 'main_color_model.g.dart';

@HiveType(typeId: 2)
enum MainColors {
  @HiveField(0)
  blue,
  @HiveField(1)
  red,
  @HiveField(2)
  green,
}
