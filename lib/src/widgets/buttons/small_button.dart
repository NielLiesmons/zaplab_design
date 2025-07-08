import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabSmallButton extends StatelessWidget {
  const LabSmallButton({
    super.key,
    required this.children,
    this.onTap,
    this.onLongPress,
    this.onChevronTap,
    this.gradient,
    this.hoveredGradient,
    this.pressedGradient,
    this.color,
    this.hoveredColor,
    this.pressedColor,
    this.square = false,
    this.rounded = false,
    this.padding,
  });

  final List<Widget> children;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onChevronTap;
  final Gradient? gradient;
  final Gradient? hoveredGradient;
  final Gradient? pressedGradient;
  final Color? color;
  final Color? hoveredColor;
  final Color? pressedColor;
  final bool square;
  final bool rounded;
  final LabEdgeInsets? padding;

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
          scaleFactor = 0.97;
        } else if (state == TapState.hover) {
          scaleFactor = 1.01;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: Semantics(
            enabled: true,
            selected: true,
            child: LabSmallButtonLayout(
              content: children,
              square: square,
              rounded: rounded,
              onChevronTap: onChevronTap,
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
              padding: padding,
            ),
          ),
        );
      },
    );
  }
}

class LabSmallButtonLayout extends StatelessWidget {
  const LabSmallButtonLayout({
    super.key,
    required this.content,
    this.gradient,
    this.backgroundColor,
    this.onChevronTap,
    this.square = false,
    this.rounded = false,
    this.padding,
  });

  final List<Widget> content;
  final Gradient? gradient;
  final Color? backgroundColor;
  final VoidCallback? onChevronTap;
  final bool square;
  final bool rounded;
  final LabEdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final buttonHeight = theme.sizes.s32;

    return LabContainer(
      decoration: BoxDecoration(
        borderRadius: rounded
            ? theme.radius.asBorderRadius().rad16
            : theme.radius.asBorderRadius().rad8,
        gradient: gradient,
        color: gradient == null ? backgroundColor : null,
      ),
      height: buttonHeight,
      width: square ? buttonHeight : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          LabContainer(
            padding: padding ??
                (square
                    ? null
                    : const LabEdgeInsets.symmetric(
                        horizontal: LabGapSize.s12,
                      )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: content,
            ),
          ),
          if (onChevronTap != null) ...[
            LabDivider.vertical(
              color: theme.colors.whiteEnforced.withValues(alpha: 0.33),
            ),
            GestureDetector(
              onTap: onChevronTap,
              behavior: HitTestBehavior.opaque,
              child: LabContainer(
                padding: const LabEdgeInsets.only(
                  left: LabGapSize.s8,
                  right: LabGapSize.s8,
                  top: LabGapSize.s2,
                  bottom: LabGapSize.none,
                ),
                child: LabIcon.s4(
                  theme.icons.characters.chevronDown,
                  outlineColor:
                      theme.colors.whiteEnforced.withValues(alpha: 0.66),
                  outlineThickness: LabLineThicknessData.normal().medium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
