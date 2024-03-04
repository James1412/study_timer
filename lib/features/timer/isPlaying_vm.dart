import 'package:flutter/material.dart';

class IsPlayingViewModel extends ChangeNotifier {
  bool isPlaying = false;

  void changeIsPlaying(bool val) {
    isPlaying = val;
    notifyListeners();
  }
}
