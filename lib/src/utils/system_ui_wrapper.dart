import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';

class AppScrollBehavior extends ScrollBehavior {
  const AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Removes the glow effect
  }

  @override
  ScrollBehavior copyWith({
    ScrollPhysics? physics,
    bool? scrollbars,
    bool? overscroll,
    Set<PointerDeviceKind>? dragDevices,
    TargetPlatform? platform,
    Set<LogicalKeyboardKey>? pointerAxisModifiers,
    MultitouchDragStrategy? multitouchDragStrategy,
  }) {
    return const AppScrollBehavior();
  }

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: child,
    );
  }
}

class AppResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const AppResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = AppTheme.of(context).system.scale;

        return ScrollConfiguration(
          behavior: const AppScrollBehavior(),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: Size(
                constraints.maxWidth,
                constraints.maxHeight,
              ),
            ),
            child: Center(
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.topCenter,
                  maxWidth: constraints.maxWidth / scale,
                  minWidth: constraints.maxWidth / scale,
                  maxHeight: constraints.maxHeight / scale,
                  minHeight: constraints.maxHeight / scale,
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topCenter,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
