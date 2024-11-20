import 'package:tap_builder/tap_builder.dart';
import 'package:zapchat_design/zapchat_design.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.content,
    this.onTap,
    this.onLongPress,
    this.mainAxisSize = MainAxisSize.min,
    this.inactiveGradient,
    this.hoveredGradient,
    this.pressedGradient,
    this.inactiveColor,
    this.hoveredColor,
    this.pressedColor,
  }) : super(key: key);

  final List<Widget> content;
  final MainAxisSize mainAxisSize;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  // Gradients
  final Gradient? inactiveGradient;
  final Gradient? hoveredGradient;
  final Gradient? pressedGradient;

  // Solid Colors
  final Color? inactiveColor;
  final Color? hoveredColor;
  final Color? pressedColor;

  @override
  Widget build(BuildContext context) {
    return TapBuilder(
      onTap: onTap,
      onLongPress: onLongPress,
      builder: (context, state, hasFocus) {
        switch (state) {
          case TapState.hover:
            return Semantics(
              enabled: true,
              selected: true,
              child: AppButtonLayout(
                content: content,
                mainAxisSize: mainAxisSize,
                gradient: hoveredGradient,
                backgroundColor: hoveredColor,
              ),
            );
          case TapState.pressed:
            return Semantics(
              enabled: true,
              selected: true,
              child: AppButtonLayout(
                content: content,
                mainAxisSize: mainAxisSize,
                gradient: pressedGradient,
                backgroundColor: pressedColor,
              ),
            );
          default:
            return Semantics(
              enabled: true,
              selected: true,
              child: AppButtonLayout(
                content: content,
                mainAxisSize: mainAxisSize,
                gradient: inactiveGradient,
                backgroundColor: inactiveColor,
              ),
            );
        }
      },
    );
  }
}

class AppButtonLayout extends StatelessWidget {
  const AppButtonLayout({
    Key? key,
    required this.content,
    this.mainAxisSize = MainAxisSize.min,
    this.gradient,
    this.backgroundColor,
  }) : super(key: key);

  final List<Widget> content;
  final MainAxisSize mainAxisSize;
  final Gradient? gradient;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AnimatedContainer(
      duration: theme.durations.fast,
      decoration: BoxDecoration(
        borderRadius: theme.radius.asBorderRadius().rad16,
        gradient: gradient,
        color: gradient == null
            ? backgroundColor
            : null, // Use color if gradient is null
      ),
      padding: EdgeInsets.symmetric(
        vertical: theme.spacing.s12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: mainAxisSize,
        children: content,
      ),
    );
  }
}
