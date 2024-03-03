import 'package:flutter/material.dart';

class DarkModelViewModel extends ChangeNotifier {
  bool isDarkMode = false;

  void setDarkMode(bool val) {
    isDarkMode = val;
    notifyListeners();
  }
}
