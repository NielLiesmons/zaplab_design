import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.content,
    this.onTap,
    this.onLongPress,
    this.inactiveGradient,
    this.hoveredGradient,
    this.pressedGradient,
    this.inactiveColor,
    this.hoveredColor,
    this.pressedColor,
    this.square = false,
  });

  final List<Widget> content;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Gradient? inactiveGradient;
  final Gradient? hoveredGradient;
  final Gradient? pressedGradient;
  final Color? inactiveColor;
  final Color? hoveredColor;
  final Color? pressedColor;
  final bool square;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    // Determine the gradients/colors to use
    final defaultGradient = theme.colors.blurple;

    final effectiveInactiveGradient =
        inactiveColor != null ? null : (inactiveGradient ?? defaultGradient);
    final effectiveHoveredGradient = inactiveColor != null
        ? null
        : (hoveredGradient ?? effectiveInactiveGradient);
    final effectivePressedGradient = inactiveColor != null
        ? null
        : (pressedGradient ?? effectiveInactiveGradient);

    final effectiveInactiveColor = inactiveColor;
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
            child: AppButtonLayout(
              content: content,
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

class AppButtonLayout extends StatelessWidget {
  const AppButtonLayout({
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
    final theme = AppTheme.of(context);
    final buttonHeight = theme.sizes.s38;

    return AppContainer(
      decoration: BoxDecoration(
        borderRadius: theme.radius.asBorderRadius().rad16,
        gradient: gradient,
        color: gradient == null ? backgroundColor : null,
      ),
      height: buttonHeight,
      width: square ? buttonHeight : null,
      padding: square
          ? null
          : const AppEdgeInsets.symmetric(
              horizontal: AppGapSize.s16,
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: content,
      ),
    );
  }
}
