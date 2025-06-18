import 'package:zaplab_design/zaplab_design.dart';

class LabPanel extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final LabEdgeInsets? padding;
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? radius;
  final bool isLight;

  const LabPanel({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.color,
    this.gradient,
    this.radius,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isInsideScope = LabScope.of(context);
    final isInsideModal = ModalScope.of(context);
    final (isInsideMessage, _) = MessageBubbleScope.of(context);

    return LabContainer(
      padding: padding ?? const LabEdgeInsets.all(LabGapSize.s16),
      width: width ?? double.infinity,
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: gradient == null
            ? (color ??
                (isLight
                    ? theme.colors.white8
                    : (isInsideMessage
                        ? theme.colors.white8
                        : (isInsideModal || isInsideScope
                            ? theme.colors.black33
                            : theme.colors.gray66))))
            : null,
        gradient: gradient,
        borderRadius: radius ?? theme.radius.asBorderRadius().rad16,
      ),
      child: child,
    );
  }
}
