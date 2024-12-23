import 'package:flutter/widgets.dart';
import 'dart:io' show Platform;

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

        // Only adjust for keyboard on mobile platforms
        final keyboardHeight = (Platform.isIOS || Platform.isAndroid)
            ? MediaQuery.of(context).viewInsets.bottom
            : 0.0;

        final availableHeight = constraints.maxHeight - keyboardHeight;

        return MediaQuery(
          // Provide adjusted metrics to child widgets
          data: MediaQuery.of(context).copyWith(
            size: Size(
              constraints.maxWidth,
              availableHeight,
            ),
          ),
          child: Center(
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.topCenter,
                maxWidth: constraints.maxWidth / scale,
                minWidth: constraints.maxWidth / scale,
                maxHeight: availableHeight / scale,
                minHeight: availableHeight / scale,
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
