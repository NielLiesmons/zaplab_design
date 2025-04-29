import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class AppBottomBarLongText extends StatelessWidget {
  final Function(Model) onZapTap;
  final Function(Model) onPlayTap;
  final Function(Model) onReplyTap;
  final Function(Model) onVoiceTap;
  final Function(Model) onActions;
  final Model model;

  const AppBottomBarLongText({
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
    final theme = AppTheme.of(context);

    return AppBottomBar(
      child: Row(
        children: [
          AppButton(
            inactiveGradient: theme.colors.blurple,
            onTap: () => onZapTap(model),
            square: true,
            children: [
              AppIcon.s20(
                theme.icons.characters.zap,
                color: theme.colors.whiteEnforced,
              ),
            ],
          ),
          const AppGap.s12(),
          AppButton(
            inactiveColor: theme.colors.white16,
            onTap: () => onPlayTap(model),
            square: true,
            children: [
              AppIcon.s12(theme.icons.characters.play,
                  color: theme.colors.white66),
            ],
          ),
          const AppGap.s12(),
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
                      left: AppGapSize.s14,
                      right: AppGapSize.s12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppIcon.s12(
                          theme.icons.characters.reply,
                          outlineThickness:
                              AppLineThicknessData.normal().medium,
                          outlineColor: theme.colors.white33,
                        ),
                        const AppGap.s8(),
                        AppText.med14('Reply', color: theme.colors.white33),
                        const Spacer(),
                        TapBuilder(
                          onTap: () => onVoiceTap(model),
                          builder: (context, state, hasFocus) {
                            return AppIcon.s18(theme.icons.characters.voice,
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
          const AppGap.s12(),
          AppButton(
            square: true,
            inactiveColor: theme.colors.black33,
            onTap: () => onActions(model),
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
