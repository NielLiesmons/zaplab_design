import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class LabBottomBarContentFeed extends StatelessWidget {
  const LabBottomBarContentFeed({
    super.key,
    this.onAddTap,
    this.onSearchTap,
    this.onActions,
  });

  final VoidCallback? onAddTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onActions;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabBottomBar(
      child: Row(
        children: [
          LabButton(
            square: true,
            children: [
              LabIcon.s12(theme.icons.characters.plus,
                  outlineThickness: LabLineThicknessData.normal().thick,
                  outlineColor: theme.colors.white66),
            ],
            color: theme.colors.white16,
            onTap: onAddTap,
          ),
          const LabGap.s12(),
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
                    child: LabContainer(
                      height: theme.sizes.s40,
                      decoration: BoxDecoration(
                        color: theme.colors.black33,
                        borderRadius: theme.radius.asBorderRadius().rad16,
                        border: Border.all(
                          color: theme.colors.white33,
                          width: LabLineThicknessData.normal().thin,
                        ),
                      ),
                      padding: const LabEdgeInsets.only(
                        left: LabGapSize.s12,
                        right: LabGapSize.s8,
                      ),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LabIcon.s18(theme.icons.characters.search,
                                outlineThickness:
                                    LabLineThicknessData.normal().medium,
                                outlineColor: theme.colors.white33),
                            const LabGap.s8(),
                            LabText.med14('Search',
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
          const LabGap.s12(),
          LabButton(
            square: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LabIcon.s8(theme.icons.characters.chevronUp,
                      outlineThickness: LabLineThicknessData.normal().medium,
                      outlineColor: theme.colors.white66),
                  const LabGap.s2(),
                ],
              ),
            ],
            color: theme.colors.black33,
            onTap: onActions,
          ),
        ],
      ),
    );
  }
}
