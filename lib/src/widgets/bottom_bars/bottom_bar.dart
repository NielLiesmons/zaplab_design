import 'package:zaplab_design/zaplab_design.dart';
import 'dart:ui';

class LabBottomBar extends StatelessWidget {
  LabBottomBar({
    super.key,
    required this.child,
    bool? roundedTop,
  }) : roundedTop = roundedTop ?? (LabPlatformUtils.isMobile);

  final Widget child;
  final bool roundedTop;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final bottomPadding =
        LabPlatformUtils.isMobile ? LabGapSize.s4 : LabGapSize.s16;

    return LabScope(
      isInsideScope: true,
      child: LabContainer(
        decoration: BoxDecoration(
          borderRadius: roundedTop
              ? BorderRadius.vertical(top: const LabRadiusData.normal().rad32)
              : null,
          border: Border(
            top: BorderSide(
              color: theme.colors.white16,
              width: LabLineThicknessData.normal().thin,
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: roundedTop
              ? BorderRadius.vertical(top: const LabRadiusData.normal().rad32)
              : BorderRadius.zero,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: LabContainer(
              padding: LabEdgeInsets.only(
                left: LabGapSize.s16,
                right: LabGapSize.s16,
                top: LabGapSize.s16,
                bottom: bottomPadding,
              ),
              decoration: BoxDecoration(color: theme.colors.gray66),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
                  const LabBottomSafeArea(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
