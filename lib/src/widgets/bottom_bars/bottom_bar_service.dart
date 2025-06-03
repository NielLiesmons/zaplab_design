import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class AppBottomBarService extends StatelessWidget {
  final Function(Service) onAddLabelTap;
  final Function(Service) onMailTap;
  final Function(Service) onVoiceTap;
  final Function(Service) onActions;
  final Service service;

  const AppBottomBarService({
    super.key,
    required this.onAddLabelTap,
    required this.onMailTap,
    required this.onVoiceTap,
    required this.onActions,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppBottomBar(
      child: Row(
        children: [
          AppButton(
            inactiveColor: theme.colors.white16,
            square: true,
            onTap: () => onAddLabelTap(service),
            children: [
              AppIcon.s20(
                theme.icons.characters.label,
                color: theme.colors.white33,
              ),
            ],
          ),
          const AppGap.s12(),
          Expanded(
            child: TapBuilder(
              onTap: () => onMailTap(service),
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
                      left: AppGapSize.s16,
                      right: AppGapSize.s12,
                    ),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppIcon(
                            theme.icons.characters.mail,
                            outlineColor: theme.colors.white33,
                            outlineThickness:
                                AppLineThicknessData.normal().medium,
                          ),
                          const AppGap.s12(),
                          AppText.med14(
                              'Mail ${service.author.value?.name ?? formatNpub(service.author.value?.npub ?? '')}',
                              color: theme.colors.white33),
                          const Spacer(),
                        ],
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
            onTap: () => onActions(service),
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
