import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class AppBottomBarChat extends StatelessWidget {
  final VoidCallback? onAddTap;
  final VoidCallback? onMessageTap;
  final VoidCallback? onVoiceTap;
  final VoidCallback? onActions;
  final String? draftMessage;
  final NostrModelResolver onResolveModel;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;

  const AppBottomBarChat({
    super.key,
    required this.onAddTap,
    required this.onMessageTap,
    required this.onVoiceTap,
    required this.onActions,
    this.draftMessage,
    required this.onResolveModel,
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
              onTap: onMessageTap,
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
                        width: LineThicknessData.normal().thin,
                      ),
                    ),
                    padding: const AppEdgeInsets.only(
                      left: AppGapSize.s16,
                      right: AppGapSize.s12,
                    ),
                    child: Center(
                      child: draftMessage != null
                          ? AppCompactTextRenderer(
                              content: draftMessage!,
                              maxLines: 1,
                              onResolveModel: onResolveModel,
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
                                  onTap: onVoiceTap,
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
            onTap: onActions,
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
          ),
        ],
      ),
    );
  }
}
