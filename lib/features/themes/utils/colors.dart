import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/themes/view_models/dark_mode_vm.dart';
import 'package:study_timer/features/themes/view_models/main_color_vm.dart';

Color blueColor = const Color(0xff607AFC);
Color redColor = const Color(0xffEC6227);
Color greenColor = const Color(0xFF4CAF50);

Color darkBackground(WidgetRef ref) {
  if (ref.watch(mainColorProvider) == blueColor) {
    return const Color(0xff1C1D22);
  } else if (ref.watch(mainColorProvider) == redColor) {
    return const Color(0xff1D1A1A);
  }
  return const Color.fromARGB(255, 22, 22, 22);
}

Color darkNavigationBar(WidgetRef ref) {
  if (ref.watch(mainColorProvider) == blueColor) {
    return const Color(0xff22232A);
  } else if (ref.watch(mainColorProvider) == redColor) {
    return const Color(0xff2A2222);
  }
  return const Color(0xff222A22);
}

Color lightBackground(WidgetRef ref) {
  if (ref.watch(mainColorProvider) == blueColor) {
    return const Color(0xfff2f2f2);
  } else if (ref.watch(mainColorProvider) == redColor) {
    return const Color(0xffF2F0F0);
  }
  return const Color(0xffF0F2F0);
}

Color lightNavigationBar = Colors.white;

Color getStatsBoxColor(WidgetRef ref) {
  if (ref.watch(darkmodeProvider)) {
    return ref.watch(mainColorProvider).withOpacity(0.1);
  }
  return ref.watch(mainColorProvider).withOpacity(0.05);
}
