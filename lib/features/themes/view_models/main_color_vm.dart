import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/themes/models/main_color_model.dart';
import 'package:study_timer/features/themes/repos/main_color_repo.dart';
import 'package:study_timer/features/themes/utils/colors.dart';

class MainColorViewModel extends Notifier<Color> {
  final MainColorRepository _repository = MainColorRepository();

  void changeMainColor(MainColors color) {
    state = getMainColor(color);
    _repository.setMainColor(color);
  }

  @override
  Color build() {
    if (_repository.getMainColor == null) {
      return getMainColor(MainColors.blue);
    }
    return getMainColor(_repository.getMainColor!);
  }
}

final mainColorProvider = NotifierProvider<MainColorViewModel, Color>(
  () => MainColorViewModel(),
);
