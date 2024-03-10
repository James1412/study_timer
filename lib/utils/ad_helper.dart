import 'dart:io';

class AdHelper {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3496653110999581/2642320022';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3496653110999581/3185245501';
    }
    throw UnsupportedError("Unsupported platform");
  }
}
