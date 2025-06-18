import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LabKeyboardSubmitHandler extends StatelessWidget {
  final Widget child;
  final VoidCallback onSubmit;
  final bool enabled;

  const LabKeyboardSubmitHandler({
    super.key,
    required this.child,
    required this.onSubmit,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (!enabled) return KeyEventResult.ignored;

        if (event.logicalKey == LogicalKeyboardKey.enter &&
            (HardwareKeyboard.instance.isMetaPressed ||
                HardwareKeyboard.instance.isControlPressed)) {
          onSubmit();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}
