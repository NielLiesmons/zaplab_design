import 'package:zaplab_design/zaplab_design.dart';

class AppPanel extends StatelessWidget {
  final Widget child;
  final AppEdgeInsets? padding;
  final Color? color;
  final Gradient? gradient;
  final bool isLight;

  const AppPanel({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.gradient,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);
    final isInsideMessage = MessageBubbleScope.of(context);

    return AppContainer(
      padding: padding ?? const AppEdgeInsets.all(AppGapSize.s16),
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: gradient == null
            ? (color ??
                (isInsideMessage
                    ? theme.colors.white8
                    : (isInsideModal
                        ? (isLight ? theme.colors.white8 : theme.colors.black33)
                        : theme.colors.grey66)))
            : null,
        gradient: gradient,
        borderRadius: theme.radius.asBorderRadius().rad16,
      ),
      child: child,
    );
  }
}
