import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class LabBottomBarProfile extends StatelessWidget {
  final Function(Profile) onAddLabelTap;
  final Function(Profile) onMailTap;
  final Function(Profile) onVoiceTap;
  final Function(Profile) onActions;
  final Profile profile;

  const LabBottomBarProfile({
    super.key,
    required this.onAddLabelTap,
    required this.onMailTap,
    required this.onVoiceTap,
    required this.onActions,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabBottomBar(
      child: Row(
        children: [
          LabButton(
            gradient: theme.colors.blurple,
            onTap: () => onAddLabelTap(profile),
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
            child: TapBuilder(
              onTap: () => onMailTap(profile),
              builder: (context, state, hasFocus) {
                double scaleFactor = 1.0;
                if (state == TapState.pressed) {
                  scaleFactor = 0.99;
                } else if (state == TapState.hover) {
                  scaleFactor = 1.005;
                }

                return Transform.scale(
                  scale: scaleFactor,
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
                      left: LabGapSize.s16,
                      right: LabGapSize.s12,
                    ),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LabIcon(
                            theme.icons.characters.mail,
                            outlineColor: theme.colors.white33,
                            outlineThickness:
                                LabLineThicknessData.normal().medium,
                          ),
                          const LabGap.s12(),
                          LabText.med14(
                            'Mail ${profile.name ?? formatNpub(profile.npub)}',
                            color: theme.colors.white33,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                        ],
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
            color: theme.colors.black33,
            onTap: () => onActions(profile),
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
