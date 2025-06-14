import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppBottomBarHome extends StatelessWidget {
  const AppBottomBarHome({
    super.key,
    this.onZapTap,
    this.onAddTap,
    this.onSearchTap,
    this.onActions,
  });

  final VoidCallback? onZapTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onActions;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppBottomBar(
      child: Row(
        children: [
          if (onZapTap != null)
            AppButton(
              square: true,
              onTap: onZapTap,
              children: [
                AppIcon.s20(theme.icons.characters.zap,
                    color: theme.colors.whiteEnforced),
              ],
            ),
          if (onZapTap != null) const AppGap.s12(),
          if (onAddTap != null)
            AppButton(
              square: true,
              inactiveColor: theme.colors.white16,
              onTap: onAddTap,
              children: [
                AppIcon.s12(theme.icons.characters.plus,
                    outlineThickness: AppLineThicknessData.normal().thick,
                    outlineColor: theme.colors.white66),
              ],
            ),
          const AppGap.s12(),
          Expanded(
            child: TapBuilder(
              onTap: onSearchTap,
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
                      height: theme.sizes.s40,
                      decoration: BoxDecoration(
                        color: theme.colors.black33,
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
                          children: [
                            AppIcon.s18(theme.icons.characters.search,
                                outlineThickness:
                                    AppLineThicknessData.normal().medium,
                                outlineColor: theme.colors.white33),
                            const AppGap.s8(),
                            AppText.med14('Search',
                                color: theme.colors.white33),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const AppGap.s12(),
          AppButton(
            square: true,
            inactiveColor: theme.colors.black33,
            onTap: onActions,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon.s8(theme.icons.characters.chevronUp,
                      outlineThickness: AppLineThicknessData.normal().medium,
                      outlineColor: theme.colors.white66),
                  const AppGap.s2(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
