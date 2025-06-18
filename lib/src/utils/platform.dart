import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'dart:ui' show PlatformDispatcher;

class LabPlatformUtils {
  static bool get isWeb => kIsWeb;
  static bool get isMobile =>
      (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) || isMobileWeb;
  static bool get isDesktop =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  static bool get isMobileWeb {
    if (!kIsWeb) return false;
    final view = PlatformDispatcher.instance.views.first;
    final logicalSize = view.physicalSize / view.devicePixelRatio;
    return logicalSize.width < 600; // Typical mobile breakpoint
  }
}
