import 'package:zaplab_design/zaplab_design.dart';
import 'dart:ui';

class AppBottomBar extends StatelessWidget {
  AppBottomBar({
    super.key,
    required this.child,
    bool? roundedTop,
  }) : roundedTop = roundedTop ?? (PlatformUtils.isMobile);

  final Widget child;
  final bool roundedTop;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final bottomPadding =
        PlatformUtils.isMobile ? AppGapSize.s4 : AppGapSize.s16;

    return AppContainer(
      decoration: BoxDecoration(
        borderRadius: roundedTop
            ? BorderRadius.vertical(top: const AppRadiusData.normal().rad32)
            : null,
        border: Border(
          top: BorderSide(
            color: theme.colors.white16,
            width: LineThicknessData.normal().thin,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: roundedTop
            ? BorderRadius.vertical(top: const AppRadiusData.normal().rad32)
            : BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: AppContainer(
            padding: AppEdgeInsets.only(
              left: AppGapSize.s16,
              right: AppGapSize.s16,
              top: AppGapSize.s16,
              bottom: bottomPadding,
            ),
            decoration: BoxDecoration(color: theme.colors.grey66),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                child,
                const AppBottomSafeArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
