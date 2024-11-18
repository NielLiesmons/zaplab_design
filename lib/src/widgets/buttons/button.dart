import 'package:flutter/widgets.dart';
import 'package:tap_builder/tap_builder.dart';

class AppButton extends StatelessWidget {
  final List<Widget>
      content; // Horizontal row of whatever Icons and/or Text you need
  final double spacing;
  final Color normalColor;
  final Color inactiveColor;
  final Color hoverColor;
  final Color pressedColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AppButton({
    required this.content,
    required this.spacing,
    required this.normalColor,
    required this.inactiveColor,
    required this.hoverColor,
    required this.pressedColor,
    this.onTap,
    this.onLongPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapBuilder(
      onTap: onTap,
      onLongPress: onLongPress,
      builder: (context, state, hasFocus) {
        final backgroundColor = _getBackgroundColor(state);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildContentWithSpacing(),
          ),
        );
      },
    );
  }

  /// Determines the background color based on the current TapState.
  Color _getBackgroundColor(TapState state) {
    switch (state) {
      case TapState.pressed:
        return pressedColor;
      case TapState.hover:
        return hoverColor;
      case TapState.inactive:
        return normalColor;
      case TapState.disabled:
        return inactiveColor;
    }
  }

  /// Adds spacing between content widgets.
  List<Widget> _buildContentWithSpacing() {
    return content.map((widget) {
      final index = content.indexOf(widget);
      return Padding(
        padding:
            EdgeInsets.only(right: index != content.length - 1 ? spacing : 0.0),
        child: widget,
      );
    }).toList();
  }
}
