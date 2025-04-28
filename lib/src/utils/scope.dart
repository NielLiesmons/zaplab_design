import 'package:flutter/widgets.dart';

class Scope extends InheritedWidget {
  final bool isInsideScope;

  const Scope({
    super.key,
    required this.isInsideScope,
    required super.child,
  });

  static bool of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<Scope>();
    return scope?.isInsideScope ?? false;
  }

  @override
  bool updateShouldNotify(Scope oldWidget) {
    return isInsideScope != oldWidget.isInsideScope;
  }
}
