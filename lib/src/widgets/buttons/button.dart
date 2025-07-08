import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabButton extends StatelessWidget {
  const LabButton({
    super.key,
    this.children,
    this.text,
    this.onTap,
    this.onLongPress,
    this.gradient,
    this.hoveredGradient,
    this.pressedGradient,
    this.color,
    this.hoveredColor,
    this.pressedColor,
    this.square = false,
  }) : assert(children != null || text != null,
            'Either children or text must be provided');

  final List<Widget>? children;
  final String? text;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Gradient? gradient;
  final Gradient? hoveredGradient;
  final Gradient? pressedGradient;
  final Color? color;
  final Color? hoveredColor;
  final Color? pressedColor;
  final bool square;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    // Determine the gradients/colors to use
    final defaultGradient = theme.colors.blurple;

    final effectiveInactiveGradient =
        color != null ? null : (gradient ?? defaultGradient);
    final effectiveHoveredGradient =
        color != null ? null : (hoveredGradient ?? effectiveInactiveGradient);
    final effectivePressedGradient =
        color != null ? null : (pressedGradient ?? effectiveInactiveGradient);

    final effectiveInactiveColor = color;
    final effectiveHoveredColor = hoveredColor ?? effectiveInactiveColor;
    final effectivePressedColor = pressedColor ?? effectiveInactiveColor;

    return TapBuilder(
      onTap: onTap,
      onLongPress: onLongPress,
      builder: (context, state, hasFocus) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.99;
        } else if (state == TapState.hover) {
          scaleFactor = 1.01;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: Semantics(
            enabled: true,
            selected: true,
            child: LabButtonLayout(
              content: children ??
                  [
                    LabText.med14(
                      text!,
                      color: theme.colors.whiteEnforced,
                    ),
                  ],
              square: square,
              gradient: state == TapState.hover
                  ? effectiveHoveredGradient
                  : state == TapState.pressed
                      ? effectivePressedGradient
                      : effectiveInactiveGradient,
              backgroundColor: state == TapState.hover
                  ? effectiveHoveredColor
                  : state == TapState.pressed
                      ? effectivePressedColor
                      : effectiveInactiveColor,
            ),
          ),
        );
      },
    );
  }
}

class LabButtonLayout extends StatelessWidget {
  const LabButtonLayout({
    super.key,
    required this.content,
    this.gradient,
    this.backgroundColor,
    this.square = false,
  });

  final List<Widget> content;
  final Gradient? gradient;
  final Color? backgroundColor;
  final bool square;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final buttonHeight = theme.sizes.s38;

    return LabContainer(
      decoration: BoxDecoration(
        borderRadius: theme.radius.asBorderRadius().rad16,
        gradient: gradient,
        color: gradient == null ? backgroundColor : null,
      ),
      height: buttonHeight,
      width: square ? buttonHeight : null,
      padding: square
          ? null
          : const LabEdgeInsets.symmetric(
              horizontal: LabGapSize.s16,
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: content,
      ),
    );
  }
}
