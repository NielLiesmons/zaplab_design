import 'package:flutter/widgets.dart';

class ScrollProgressNotification {
  final double progress;
  final BuildContext context;

  ScrollProgressNotification(this.progress, this.context);

  void dispatch() {
    final element = context as Element;
    element.visitAncestorElements((element) {
      if (element.widget is ScrollProgressListener) {
        final listener = element.widget as ScrollProgressListener;
        if (listener.onNotification != null) {
          return !listener.onNotification!(this);
        }
      }
      return true;
    });
  }
}

class ScrollProgressListener extends StatelessWidget {
  final Widget child;
  final bool Function(ScrollProgressNotification)? onNotification;

  const ScrollProgressListener({
    super.key,
    required this.child,
    this.onNotification,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
