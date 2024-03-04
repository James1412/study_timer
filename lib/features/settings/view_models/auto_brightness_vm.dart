import 'package:flutter/cupertino.dart';

class AutoBrightnessViewModel extends ChangeNotifier {
  bool isAutoBrightnessControl = true;

  void changeIsAutoBrightnessControl(bool val) {
    isAutoBrightnessControl = val;
    notifyListeners();
  }
}
