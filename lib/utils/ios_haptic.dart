import 'dart:io';

import 'package:flutter/services.dart';

void iosLightFeedback() {
  if (Platform.isIOS) {
    HapticFeedback.lightImpact();
  }
}

void iosHeavyFeedback() {
  if (Platform.isIOS) {
    HapticFeedback.heavyImpact();
  }
}
