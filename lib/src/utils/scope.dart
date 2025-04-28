import 'package:flutter/widgets.dart';

class AppScope extends InheritedWidget {
  final bool isInsideScope;

  const AppScope({
    super.key,
    required this.isInsideScope,
    required super.child,
  });

  static bool of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    return scope?.isInsideScope ?? false;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) {
    return isInsideScope != oldWidget.isInsideScope;
  }
}
