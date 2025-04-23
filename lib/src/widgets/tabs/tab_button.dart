import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppTabButton extends StatelessWidget {
  const AppTabButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.count,
    this.onLongPress,
    this.isSelected = false,
  });

  final String label;
  final Widget icon;
  final int? count;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    final defaultGradient = theme.colors.blurple;
    final inactiveColor =
        isInsideModal ? theme.colors.white8 : theme.colors.gray66;

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
          child: AppContainer(
            height: theme.sizes.s32,
            decoration: BoxDecoration(
              gradient: isSelected ? defaultGradient : null,
              color: isSelected ? null : inactiveColor,
              borderRadius: theme.radius.asBorderRadius().rad32,
            ),
            padding: const AppEdgeInsets.symmetric(
              horizontal: AppGapSize.s16,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.med14(
                  label,
                  color: isSelected
                      ? theme.colors.whiteEnforced
                      : theme.colors.white,
                ),
                if (count != null && count! > 0) ...[
                  const AppGap.s8(),
                  AppText.med14(
                    count.toString(),
                    color: isSelected
                        ? theme.colors.whiteEnforced.withValues(alpha: 0.66)
                        : theme.colors.white66,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
