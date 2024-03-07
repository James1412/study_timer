import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/settings/repos/auto_brightness_repo.dart';

class AutoBrightnessViewModel extends Notifier<bool> {
  final AutoBrightnessRepository _repository = AutoBrightnessRepository();

  void changeIsAutoBrightnessControl(bool val) {
    state = val;
    _repository.setAutoBrightness(val);
  }

  @override
  bool build() {
    return _repository.getAutoBrightness ?? true;
  }
}

final autoBrightnessControlProvider =
    NotifierProvider<AutoBrightnessViewModel, bool>(
  () => AutoBrightnessViewModel(),
);
