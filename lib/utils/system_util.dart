import 'package:flutter/services.dart';
class SystemUtil{
  /*锁定屏幕为竖屏*/
  static Future<void> lockScreenDirection() {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

/*锁定屏幕为横屏幕*/
  static Future<void> lockScreenHorizontalDirection() {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
}

