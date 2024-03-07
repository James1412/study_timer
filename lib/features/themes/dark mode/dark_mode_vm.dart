import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/themes/dark%20mode/dark_mode_repo.dart';

class DarkModelViewModel extends Notifier<bool> {
  final DarkModeRepository _repository = DarkModeRepository();

  void setDarkMode(bool val) {
    state = val;
    _repository.setDarkmode(val);
  }

  @override
  bool build() {
    return _repository.getDarkmode ?? false;
  }
}

final darkmodeProvider = NotifierProvider<DarkModelViewModel, bool>(
  () => DarkModelViewModel(),
);
