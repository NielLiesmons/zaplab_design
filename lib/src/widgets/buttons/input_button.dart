import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppInputButton extends StatelessWidget {
  final VoidCallback? onTap;
  final List<Widget> children;
  final Color? backgroundColor;

  const AppInputButton({
    super.key,
    this.onTap,
    required this.children,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);
    final isInsideScope = AppScope.of(context);

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
            child: AppContainer(
              height: theme.sizes.s38,
              decoration: BoxDecoration(
                color: backgroundColor ??
                    (isInsideModal || isInsideScope
                        ? theme.colors.black33
                        : theme.colors.gray33),
                borderRadius: theme.radius.asBorderRadius().rad16,
                border: Border.all(
                  color: theme.colors.white33,
                  width: AppLineThicknessData.normal().thin,
                ),
              ),
              padding: const AppEdgeInsets.only(
                left: AppGapSize.s12,
                right: AppGapSize.s8,
              ),
              child: Center(
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
