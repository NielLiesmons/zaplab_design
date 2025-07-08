import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class LabBottomBarReply extends StatelessWidget {
  final Function(Model) onAddTap;
  final Function(Model) onReplyTap;
  final Function(Model) onVoiceTap;
  final Function(Model) onActions;
  final Model model;
  final PartialChatMessage? draftMessage;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;

  const LabBottomBarReply({
    super.key,
    required this.onAddTap,
    required this.onReplyTap,
    required this.onVoiceTap,
    required this.onActions,
    required this.model,
    this.draftMessage,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return Row(
      children: [
        LabButton(
          square: true,
          onTap: () => onAddTap(model),
          children: [
            LabIcon.s18(
              theme.icons.characters.zap,
              color: theme.colors.whiteEnforced,
            ),
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
                    left: LabGapSize.s16,
                    right: LabGapSize.s12,
                  ),
                  child: Center(
                    child: draftMessage != null
                        ? LabCompactTextRenderer(
                            model: model,
                            content: draftMessage!.event.content,
                            maxLines: 1,
                            onResolveEvent: onResolveEvent,
                            onResolveProfile: onResolveProfile,
                            onResolveEmoji: onResolveEmoji,
                            isMedium: false,
                            isWhite: true,
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LabIcon.s18(
                                theme.icons.characters.reply,
                                outlineColor: theme.colors.white33,
                                outlineThickness:
                                    LabLineThicknessData.normal().medium,
                              ),
                              const LabGap.s8(),
                              LabText.med14('Reply',
                                  color: theme.colors.white33),
                              const LabGap.s12(),
                              const Spacer(),
                              TapBuilder(
                                onTap: () => onVoiceTap(model),
                                builder: (context, state, hasFocus) {
                                  return LabIcon.s18(
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
    );
  }
}
