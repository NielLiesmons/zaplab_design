import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class LabBottomBarLongText extends StatelessWidget {
  final Function(Model) onZapTap;
  final Function(Model) onPlayTap;
  final Function(Model) onReplyTap;
  final Function(Model) onVoiceTap;
  final Function(Model) onActions;
  final Model model;

  const LabBottomBarLongText({
    super.key,
    required this.onZapTap,
    required this.onPlayTap,
    required this.onReplyTap,
    required this.onVoiceTap,
    required this.onActions,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabBottomBar(
      child: Row(
        children: [
          LabButton(
            gradient: theme.colors.blurple,
            onTap: () => onZapTap(model),
            square: true,
            children: [
              LabIcon.s20(
                theme.icons.characters.zap,
                color: theme.colors.whiteEnforced,
              ),
            ],
          ),
          const LabGap.s12(),
          LabButton(
            color: theme.colors.white16,
            onTap: () => onPlayTap(model),
            square: true,
            children: [
              LabIcon.s12(theme.icons.characters.play,
                  color: theme.colors.white66),
            ],
          ),
          const LabGap.s12(),
          Expanded(
            child: TapBuilder(
              onTap: () => onReplyTap(model),
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
                      left: LabGapSize.s14,
                      right: LabGapSize.s12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LabIcon.s12(
                          theme.icons.characters.reply,
                          outlineThickness:
                              LabLineThicknessData.normal().medium,
                          outlineColor: theme.colors.white33,
                        ),
                        const LabGap.s8(),
                        LabText.med14('Reply', color: theme.colors.white33),
                        const Spacer(),
                        TapBuilder(
                          onTap: () => onVoiceTap(model),
                          builder: (context, state, hasFocus) {
                            return LabIcon.s18(theme.icons.characters.voice,
                                color: theme.colors.white33);
                          },
                        ),
                      ],
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
            onTap: () => onActions(model),
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
