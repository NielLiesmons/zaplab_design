import 'package:tap_builder/tap_builder.dart';
import 'package:zapchat_design/zapchat_design.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.content,
    this.onTap,
    this.mainAxisSize = MainAxisSize.min,
  }) : super(key: key);

  final List<Widget> content;
  final MainAxisSize mainAxisSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) {
        switch (state) {
          case TapState.hover:
            return Semantics(
              enabled: true,
              selected: true,
              child: AppButtonLayout.hovered(
                content: content,
                mainAxisSize: mainAxisSize,
              ),
            );
          case TapState.pressed:
            return Semantics(
              enabled: true,
              selected: true,
              child: AppButtonLayout.pressed(
                content: content,
                mainAxisSize: mainAxisSize,
              ),
            );
          default:
            return Semantics(
              enabled: true,
              selected: true,
              child: AppButtonLayout.inactive(
                content: content,
                mainAxisSize: mainAxisSize,
              ),
            );
        }
      },
    );
  }
}

enum AppButtonState {
  inactive,
  hovered,
  pressed,
}

class AppButtonLayout extends StatelessWidget {
  const AppButtonLayout.inactive({
    Key? key,
    required this.content,
    this.mainAxisSize = MainAxisSize.min,
    this.inactiveBackgroundColor,
    this.hoveredBackgroundColor,
    this.pressedBackgroundColor,
    this.foregroundColor,
  })  : _state = AppButtonState.inactive,
        super(key: key);

  const AppButtonLayout.hovered({
    Key? key,
    required this.content,
    this.mainAxisSize = MainAxisSize.min,
    this.inactiveBackgroundColor,
    this.hoveredBackgroundColor,
    this.pressedBackgroundColor,
    this.foregroundColor,
  })  : _state = AppButtonState.hovered,
        super(key: key);

  const AppButtonLayout.pressed({
    Key? key,
    required this.content,
    this.mainAxisSize = MainAxisSize.min,
    this.inactiveBackgroundColor,
    this.hoveredBackgroundColor,
    this.pressedBackgroundColor,
    this.foregroundColor,
  })  : _state = AppButtonState.pressed,
        super(key: key);

  final List<Widget> content;
  final MainAxisSize mainAxisSize;
  final AppButtonState _state;
  final Color? inactiveBackgroundColor;
  final Color? hoveredBackgroundColor;
  final Color? pressedBackgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final gradient = () {
      switch (_state) {
        case AppButtonState.inactive:
          return inactiveBackgroundColor != null
              ? LinearGradient(
                  colors: [inactiveBackgroundColor!, inactiveBackgroundColor!])
              : theme.colors.blurple;
        case AppButtonState.hovered:
          return hoveredBackgroundColor != null
              ? LinearGradient(
                  colors: [hoveredBackgroundColor!, hoveredBackgroundColor!])
              : theme.colors.blurple;
        case AppButtonState.pressed:
          return pressedBackgroundColor != null
              ? LinearGradient(
                  colors: [pressedBackgroundColor!, pressedBackgroundColor!])
              : theme.colors.blurple;
      }
    }();

    return AnimatedContainer(
      duration: theme.durations.fast,
      decoration: BoxDecoration(
        borderRadius: theme.radius.asBorderRadius().rad16,
        gradient: gradient,
      ),
      padding: EdgeInsets.symmetric(
        vertical: theme.spacing.s12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: mainAxisSize,
        children: [
          ...content,
        ],
      ),
    );
  }
}
