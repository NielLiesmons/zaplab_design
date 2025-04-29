import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class AppBottomBarProfile extends StatelessWidget {
  final Function(Profile) onAddLabelTap;
  final Function(Profile) onMessageTap;
  final Function(Profile) onVoiceTap;
  final Function(Profile) onActions;
  final Profile profile;
  final PartialChatMessage? draftMessage;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;

  const AppBottomBarProfile({
    super.key,
    required this.onAddLabelTap,
    required this.onMessageTap,
    required this.onVoiceTap,
    required this.onActions,
    required this.profile,
    this.draftMessage,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppBottomBar(
      child: Row(
        children: [
          AppButton(
            inactiveGradient: theme.colors.blurple,
            onTap: () => onAddLabelTap(profile),
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
            child: TapBuilder(
              onTap: () => onMessageTap(profile),
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
                      child: draftMessage != null
                          ? AppCompactTextRenderer(
                              content: draftMessage!.event.content,
                              maxLines: 1,
                              onResolveEvent: onResolveEvent,
                              onResolveProfile: onResolveProfile,
                              onResolveEmoji: (_) async => '',
                              isMedium: false,
                              isWhite: true,
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppText.med14('Message',
                                    color: theme.colors.white33),
                                const Spacer(),
                                TapBuilder(
                                  onTap: () => onVoiceTap(profile),
                                  builder: (context, state, hasFocus) {
                                    return AppIcon.s18(
                                        theme.icons.characters.voice,
                                        color: theme.colors.white33);
                                  },
                                ),
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
            onTap: () => onActions(profile),
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
