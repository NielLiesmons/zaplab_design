import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:ui';

class AppPanelButton extends StatelessWidget {
  const AppPanelButton({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.color,
    this.gradient,
    this.padding,
    this.count,
    this.isLight = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final Gradient? gradient;
  final AppEdgeInsets? padding;
  final int? count;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        TapBuilder(
          onTap: onTap,
          onLongPress: onLongPress,
          builder: (context, state, isFocused) {
            double scaleFactor = 1.0;
            if (state == TapState.pressed) {
              scaleFactor = 0.99;
            } else if (state == TapState.hover) {
              scaleFactor = 1.0;
            }

            return Transform.scale(
              scale: scaleFactor,
              child: AppPanel(
                color: color,
                gradient: gradient,
                padding: padding,
                isLight: isLight,
                child: child,
              ),
            );
          },
        ),
        if (count != null && count! > 0)
          Positioned(
            top: -theme.sizes.s6,
            right: -theme.sizes.s6,
            child: ClipRRect(
              borderRadius: theme.radius.asBorderRadius().rad16,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: SizedBox(
                  height: theme.sizes.s20,
                  child: AppContainer(
                    padding: const AppEdgeInsets.symmetric(
                      horizontal: AppGapSize.s8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colors.white16,
                      borderRadius: theme.radius.asBorderRadius().rad16,
                    ),
                    child: Center(
                      child: AppText.med12(
                        count.toString(),
                        color: theme.colors.white66,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
