import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class LabBottomBarWelcome extends StatelessWidget {
  final VoidCallback? onAddLabelTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onActions;
  const LabBottomBarWelcome({
    super.key,
    this.onAddLabelTap,
    this.onSearchTap,
    this.onActions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabBottomBar(
      child: Row(
        children: [
          LabButton(
            gradient: theme.colors.blurple,
            onTap: onAddLabelTap,
            children: [
              LabIcon.s12(
                theme.icons.characters.plus,
                outlineThickness: LabLineThicknessData.normal().thick,
                outlineColor: theme.colors.whiteEnforced,
              ),
              const LabGap.s8(),
              LabText.med14('Add', color: theme.colors.whiteEnforced),
              const LabGap.s4(),
            ],
          ),
          const LabGap.s12(),
          Expanded(
              child: LabInputButton(
            children: [
              LabIcon.s18(theme.icons.characters.search,
                  outlineThickness: LabLineThicknessData.normal().medium,
                  outlineColor: theme.colors.white33),
              const LabGap.s8(),
              LabText.med14('Search', color: theme.colors.white33),
            ],
          )),
          const LabGap.s12(),
          LabButton(
            square: true,
            color: theme.colors.black33,
            onTap: onActions,
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
          ),
        ],
      ),
    );
  }
}
