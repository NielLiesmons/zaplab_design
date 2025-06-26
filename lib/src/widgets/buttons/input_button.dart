import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class LabInputButton extends StatelessWidget {
  final VoidCallback? onTap;
  final List<Widget> children;
  final Color? color;
  final double? minHeight;
  final bool? topAlignment;

  const LabInputButton({
    super.key,
    this.onTap,
    required this.children,
    this.color,
    this.minHeight,
    this.topAlignment = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isInsideModal = ModalScope.of(context);
    final isInsideScope = LabScope.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.99;
        } else if (state == TapState.hover) {
          scaleFactor = 1.005;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: Semantics(
            enabled: true,
            selected: true,
            child: LabContainer(
              constraints: BoxConstraints(
                minHeight: minHeight ?? theme.sizes.s38,
              ),
              decoration: BoxDecoration(
                color: color ??
                    (isInsideModal || isInsideScope
                        ? theme.colors.black33
                        : theme.colors.gray33),
                borderRadius: theme.radius.asBorderRadius().rad16,
                border: Border.all(
                  color: theme.colors.white33,
                  width: LabLineThicknessData.normal().thin,
                ),
              ),
              padding: LabEdgeInsets.only(
                left: LabGapSize.s12,
                right: LabGapSize.s12,
                top: topAlignment == true ? LabGapSize.s8 : LabGapSize.none,
                bottom: topAlignment == true ? LabGapSize.s8 : LabGapSize.none,
              ),
              child: topAlignment == true
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    )
                  : Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
