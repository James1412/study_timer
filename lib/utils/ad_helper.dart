import 'dart:io';

class AdHelper {
  static String get timerScreenBanner {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3496653110999581/2642320022';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3496653110999581/3185245501';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get statsScreenBanner {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3496653110999581/8548859617';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3496653110999581/1424213911';
    }
    throw UnsupportedError("Unsupported platform");
  }
}
