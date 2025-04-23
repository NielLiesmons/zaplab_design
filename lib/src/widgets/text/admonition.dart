import 'package:zaplab_design/zaplab_design.dart';
import 'dart:ui';

class AppAdmonition extends StatelessWidget {
  final String type;
  final Widget child;

  const AppAdmonition({
    super.key,
    required this.type,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppGap.s12(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            AppPanel(
              color: theme.colors.gray66,
              padding: const AppEdgeInsets.only(
                left: AppGapSize.s12,
                right: AppGapSize.s12,
                top: AppGapSize.s20,
                bottom: AppGapSize.s8,
              ),
              child: child,
            ),
            Positioned(
              left: 12,
              top: -8,
              child: ClipRRect(
                borderRadius: theme.radius.asBorderRadius().rad8,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: AppContainer(
                    padding: const AppEdgeInsets.symmetric(
                      horizontal: AppGapSize.s8,
                      vertical: AppGapSize.s2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colors.white16,
                      borderRadius: theme.radius.asBorderRadius().rad8,
                    ),
                    child: AppText.h3(
                      type.toUpperCase(),
                      color: theme.colors.white66,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
