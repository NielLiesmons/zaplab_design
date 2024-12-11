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

  @override
  Widget build(BuildContext context) {
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
              gradient: state == TapState.hover
                  ? hoveredGradient
                  : state == TapState.pressed
                      ? pressedGradient
                      : inactiveGradient,
              backgroundColor: state == TapState.hover
                  ? hoveredColor
                  : state == TapState.pressed
                      ? pressedColor
                      : inactiveColor,
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
  });

  final List<Widget> content;
  final Gradient? gradient;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: theme.radius.asBorderRadius().rad16,
        gradient: gradient,
        color: gradient == null ? backgroundColor : null,
      ),
      height: theme.sizes.s38,
      padding: EdgeInsets.symmetric(
        horizontal: theme.sizes.s16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: content,
      ),
    );
  }
}
