import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:ui';

class LabPanelButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? width;
  final double? height;
  final Color? color;
  final Gradient? gradient;
  final LabEdgeInsets? padding;
  final BorderRadius? radius;
  final int? count;
  final bool isLight;
  const LabPanelButton({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
    this.color,
    this.gradient,
    this.padding,
    this.radius,
    this.count,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

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
              child: LabPanel(
                width: width,
                height: height,
                color: color,
                gradient: gradient,
                padding: padding,
                radius: radius,
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
                  child: LabContainer(
                    padding: const LabEdgeInsets.symmetric(
                      horizontal: LabGapSize.s8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colors.white16,
                      borderRadius: theme.radius.asBorderRadius().rad16,
                    ),
                    child: Center(
                      child: LabText.med12(
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
