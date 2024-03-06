import 'package:flutter_riverpod/flutter_riverpod.dart';

class DarkModelViewModel extends Notifier<bool> {
  void setDarkMode(bool val) {
    state = val;
  }

  @override
  bool build() {
    return false;
  }
}

final darkmodeProvider = NotifierProvider<DarkModelViewModel, bool>(
  () => DarkModelViewModel(),
);
