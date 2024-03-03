import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:study_timer/features/themes/dark%20mode/dark_mode_mvvm.dart';

bool isDarkMode(BuildContext context) {
  return context.watch<DarkModelViewModel>().isDarkMode;
}
