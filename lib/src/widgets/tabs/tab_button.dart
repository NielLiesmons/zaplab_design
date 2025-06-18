import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabTabButton extends StatelessWidget {
  const LabTabButton({
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
    final theme = LabTheme.of(context);
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
          child: LabContainer(
            height: theme.sizes.s32,
            decoration: BoxDecoration(
              gradient: isSelected ? defaultGradient : null,
              color: isSelected ? null : inactiveColor,
              borderRadius: theme.radius.asBorderRadius().rad32,
            ),
            padding: const LabEdgeInsets.symmetric(
              horizontal: LabGapSize.s16,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LabText.med14(
                  label,
                  color: isSelected
                      ? theme.colors.whiteEnforced
                      : theme.colors.white,
                ),
                if (count != null && count! > 0) ...[
                  const LabGap.s8(),
                  LabText.med14(
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
