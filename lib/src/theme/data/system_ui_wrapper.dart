import 'package:flutter/widgets.dart';

class AppResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double baseWidth;

  const AppResponsiveWrapper({
    super.key,
    required this.child,
    this.baseWidth = 360.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final scale = screenWidth / baseWidth;

        return Center(
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxWidth: baseWidth,
              minWidth: baseWidth,
              maxHeight: constraints.maxHeight / scale,
              minHeight: constraints.maxHeight / scale,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
