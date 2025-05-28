import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppBottomBarWelcome extends StatelessWidget {
  final VoidCallback? onAddLabelTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onActions;
  const AppBottomBarWelcome({
    super.key,
    this.onAddLabelTap,
    this.onSearchTap,
    this.onActions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppBottomBar(
      child: Row(
        children: [
          AppButton(
            inactiveGradient: theme.colors.blurple,
            onTap: onAddLabelTap,
            children: [
              AppIcon.s12(
                theme.icons.characters.plus,
                outlineThickness: AppLineThicknessData.normal().thick,
                outlineColor: theme.colors.whiteEnforced,
              ),
              const AppGap.s8(),
              AppText.med14('Add', color: theme.colors.whiteEnforced),
              const AppGap.s4(),
            ],
          ),
          const AppGap.s12(),
          Expanded(
              child: AppInputButton(
            children: [
              AppIcon.s18(theme.icons.characters.search,
                  outlineThickness: AppLineThicknessData.normal().medium,
                  outlineColor: theme.colors.white33),
              const AppGap.s8(),
              AppText.med14('Search', color: theme.colors.white33),
            ],
          )),
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
