import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppBottomBarContentFeed extends StatelessWidget {
  const AppBottomBarContentFeed({
    super.key,
    this.onAddTap,
    this.onExploreTap,
    this.onActions,
  });

  final VoidCallback? onAddTap;
  final VoidCallback? onExploreTap;
  final VoidCallback? onActions;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppBottomBar(
      child: Row(
        children: [
          AppButton(
            square: true,
            children: [
              AppIcon.s12(theme.icons.characters.plus,
                  outlineThickness: LineThicknessData.normal().thick,
                  outlineColor: theme.colors.white66),
            ],
            inactiveColor: theme.colors.white16,
            onTap: onAddTap,
          ),
          const AppGap.s12(),
          Expanded(
            child: TapBuilder(
              onTap: onExploreTap,
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
                          width: LineThicknessData.normal().thin,
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
                                    LineThicknessData.normal().medium,
                                outlineColor: theme.colors.white33),
                            const AppGap.s8(),
                            AppText.med14('Explore',
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
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon.s8(theme.icons.characters.chevronUp,
                      outlineThickness: LineThicknessData.normal().medium,
                      outlineColor: theme.colors.white66),
                  const AppGap.s2(),
                ],
              ),
            ],
            inactiveColor: theme.colors.black33,
            onTap: onActions,
          ),
        ],
      ),
    );
  }
}
