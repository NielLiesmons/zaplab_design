import 'package:zaplab_design/zaplab_design.dart';

class AppSwipePanel extends StatelessWidget {
  final Widget child;
  final AppEdgeInsets? padding;
  final Color? color;
  final Gradient? gradient;
  final bool isLight;
  final Widget? leftContent;
  final Widget? rightContent;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final double actionWidth;

  const AppSwipePanel({
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
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    return AppSwipeContainer(
      padding: padding ?? const AppEdgeInsets.all(AppGapSize.s16),
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
                    : theme.colors.grey66))
            : null,
        gradient: gradient,
        borderRadius: theme.radius.asBorderRadius().rad16,
      ),
      child: child,
    );
  }
}
