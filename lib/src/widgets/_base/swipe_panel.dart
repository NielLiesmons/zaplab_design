import 'package:zaplab_design/zaplab_design.dart';

class LabSwipePanel extends StatelessWidget {
  final Widget child;
  final LabEdgeInsets? padding;
  final Color? color;
  final Gradient? gradient;
  final bool isLight;
  final Widget? leftContent;
  final Widget? rightContent;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final double actionWidth;

  const LabSwipePanel({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.gradient,
    this.isLight = false,
    this.leftContent,
    this.rightContent,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.actionWidth = 56,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    return LabSwipeContainer(
      padding: padding ?? const LabEdgeInsets.all(LabGapSize.s16),
      leftContent: leftContent,
      rightContent: rightContent,
      onSwipeLeft: onSwipeLeft,
      onSwipeRight: onSwipeRight,
      actionWidth: actionWidth,
      decoration: BoxDecoration(
        color: gradient == null
            ? (color ??
                (isInsideModal
                    ? (isLight ? theme.colors.white8 : theme.colors.black33)
                    : theme.colors.gray66))
            : null,
        gradient: gradient,
        borderRadius: theme.radius.asBorderRadius().rad16,
      ),
      child: child,
    );
  }
}
