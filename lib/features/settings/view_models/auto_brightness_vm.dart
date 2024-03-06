import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutoBrightnessViewModel extends Notifier<bool> {
  void changeIsAutoBrightnessControl(bool val) {
    state = val;
  }

  @override
  bool build() {
    return true;
  }
}

final autoBrightnessControlProvider =
    NotifierProvider<AutoBrightnessViewModel, bool>(
  () => AutoBrightnessViewModel(),
);
