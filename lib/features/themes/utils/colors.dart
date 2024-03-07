import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/themes/models/main_color_model.dart';
import 'package:study_timer/features/themes/view_models/dark_mode_vm.dart';
import 'package:study_timer/features/themes/view_models/main_color_vm.dart';

Color darkBackground = const Color(0xff1C1D22);
Color darkNavigationBar = const Color(0xff22232A);
Color lightBackground = const Color(0xfff2f2f2);
Color lightNavigationBar = Colors.white;

Color blueButtonColor = const Color(0xff607AFC);
Color redButtonColor = const Color(0xffEC6227);

Color getMainColor(MainColors color) {
  if (color == MainColors.blue) {
    return blueButtonColor;
  } else if (color == MainColors.red) {
    return redButtonColor;
  } else {
    return Colors.green;
  }
}

Color getStatsBoxColor(WidgetRef ref) {
  if (ref.watch(darkmodeProvider)) {
    return ref.watch(mainColorProvider).withOpacity(0.1);
  }
  return ref.watch(mainColorProvider).withOpacity(0.05);
}
