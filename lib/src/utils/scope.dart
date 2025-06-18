import 'package:flutter/widgets.dart';

class LabScope extends InheritedWidget {
  final bool isInsideScope;

  const LabScope({
    super.key,
    required this.isInsideScope,
    required super.child,
  });

  static bool of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LabScope>();
    return scope?.isInsideScope ?? false;
  }

  @override
  bool updateShouldNotify(LabScope oldWidget) {
    return isInsideScope != oldWidget.isInsideScope;
  }
}
