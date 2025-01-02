import 'package:flutter/widgets.dart';

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
        const scale = 1.15;

        return MediaQuery(
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
        );
      },
    );
  }
}
