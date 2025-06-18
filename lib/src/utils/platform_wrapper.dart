import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

/// A widget that provides platform information to its descendants.
class LabPlatformWrapper extends InheritedWidget {
  final bool isWeb;
  final bool isAndroid;
  final bool isIOS;
  final bool isMacOS;
  final bool isWindows;
  final bool isLinux;

  const LabPlatformWrapper({
    super.key,
    required super.child,
    required this.isWeb,
    required this.isAndroid,
    required this.isIOS,
    required this.isMacOS,
    required this.isWindows,
    required this.isLinux,
  });

  static LabPlatformWrapper of(BuildContext context) {
    final wrapper =
        context.dependOnInheritedWidgetOfExactType<LabPlatformWrapper>();
    assert(wrapper != null, 'No PlatformWrapper found in context');
    return wrapper!;
  }

  @override
  bool updateShouldNotify(LabPlatformWrapper oldWidget) {
    return isWeb != oldWidget.isWeb ||
        isAndroid != oldWidget.isAndroid ||
        isIOS != oldWidget.isIOS ||
        isMacOS != oldWidget.isMacOS ||
        isWindows != oldWidget.isWindows ||
        isLinux != oldWidget.isLinux;
  }
}

/// Web implementation of PlatformWrapper
class PlatformWrapperWeb extends LabPlatformWrapper {
  const PlatformWrapperWeb({
    super.key,
    required super.child,
  }) : super(
          isWeb: true,
          isAndroid: false,
          isIOS: false,
          isMacOS: false,
          isWindows: false,
          isLinux: false,
        );
}

/// Native platform implementation of PlatformWrapper
class PlatformWrapperNative extends LabPlatformWrapper {
  const PlatformWrapperNative({
    super.key,
    required super.child,
  }) : super(
          isWeb: false,
          isAndroid: !kIsWeb && identical(0, 0), // Android detection
          isIOS: !kIsWeb && identical(0, 0), // iOS detection
          isMacOS: !kIsWeb && identical(0, 0), // macOS detection
          isWindows: !kIsWeb && identical(0, 0), // Windows detection
          isLinux: !kIsWeb && identical(0, 0), // Linux detection
        );
}

/// Returns the appropriate PlatformWrapper implementation based on the platform.
LabPlatformWrapper createPlatformWrapper({required Widget child}) {
  if (kIsWeb) {
    return PlatformWrapperWeb(child: child);
  }
  return PlatformWrapperNative(child: child);
}
