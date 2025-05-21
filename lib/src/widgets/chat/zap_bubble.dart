import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppZapBubble extends StatefulWidget {
  final CashuZap cashuZap;
  final bool isOutgoing;
  final Function(Model) onActions;
  final Function(Model) onReply;
  final Function(Reaction)? onReactionTap;
  final Function(Zap)? onZapTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;

  const AppZapBubble({
    super.key,
    required this.cashuZap,
    this.isOutgoing = false,
    required this.onActions,
    required this.onReply,
    this.onReactionTap,
    this.onZapTap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
  });

  @override
  State<AppZapBubble> createState() => _AppZapBubbleState();
}

class _AppZapBubbleState extends State<AppZapBubble> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isLight = theme.colors.white == const Color(0xFF000000);

    return Row(
      mainAxisAlignment: widget.isOutgoing
          ? MainAxisAlignment.end // Outgoing zaps aligned right
          : MainAxisAlignment.start, // Incoming zaps aligned left
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!widget.isOutgoing) ...[
          AppContainer(
            child: AppProfilePic.s32(widget.cashuZap.author.value),
          ),
          const AppGap.s4(),
        ] else ...[
          const AppGap.s64(),
          const AppGap.s4(),
        ],
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 28),
            child: Column(
              crossAxisAlignment: widget.isOutgoing
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                AppSwipeContainer(
                  decoration: BoxDecoration(
                    gradient: theme.colors.graydient16,
                    borderRadius: BorderRadius.only(
                      topLeft: theme.radius.rad16,
                      topRight: theme.radius.rad16,
                      bottomRight: widget.isOutgoing
                          ? theme.radius.rad4
                          : theme.radius.rad16,
                      bottomLeft: widget.isOutgoing
                          ? theme.radius.rad16
                          : theme.radius.rad4,
                    ),
                  ),
                  leftContent: AppIcon.s16(
                    theme.icons.characters.reply,
                    outlineColor: theme.colors.white66,
                    outlineThickness: AppLineThicknessData.normal().medium,
                  ),
                  rightContent: AppIcon.s10(
                    theme.icons.characters.chevronUp,
                    outlineColor: theme.colors.white66,
                    outlineThickness: AppLineThicknessData.normal().medium,
                  ),
                  onSwipeLeft: () => widget.onReply(widget.cashuZap),
                  onSwipeRight: () => widget.onActions(widget.cashuZap),
                  child: MessageBubbleScope(
                    isOutgoing: widget.isOutgoing,
                    child: LayoutBuilder(
                      builder: (context, bubbleConstraints) {
                        return IntrinsicWidth(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: bubbleConstraints.maxWidth,
                              minWidth: theme.sizes.s80,
                            ),
                            child: AppContainer(
                              padding: const AppEdgeInsets.only(
                                left: AppGapSize.s8,
                                right: AppGapSize.s8,
                                top: AppGapSize.s8,
                                bottom: AppGapSize.s2,
                              ),
                              child: Column(
                                crossAxisAlignment: widget.isOutgoing
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!widget.isOutgoing) ...[
                                    AppContainer(
                                      padding: const AppEdgeInsets.only(
                                        left: AppGapSize.s4,
                                        right: AppGapSize.s4,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (widget.cashuZap.author.value !=
                                              null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 2,
                                              ),
                                              child: Stack(
                                                children: [
                                                  AppText.bold12(
                                                    widget.cashuZap.author
                                                            .value!.name ??
                                                        formatNpub(widget
                                                            .cashuZap
                                                            .author
                                                            .value!
                                                            .pubkey),
                                                    gradient: theme.colors.gold,
                                                    textOverflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  AppText.bold12(
                                                    widget.cashuZap.author
                                                            .value!.name ??
                                                        formatNpub(widget
                                                            .cashuZap
                                                            .author
                                                            .value!
                                                            .pubkey),
                                                    color: isLight
                                                        ? theme.colors.white33
                                                        : theme.colors.white8,
                                                    textOverflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          const AppGap.s4(),
                                          AppContainer(
                                            padding:
                                                const AppEdgeInsets.symmetric(
                                              horizontal: AppGapSize.s8,
                                              vertical: AppGapSize.s2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: theme.colors.black33,
                                              borderRadius: theme.radius
                                                  .asBorderRadius()
                                                  .rad16,
                                            ),
                                            child: Row(
                                              children: [
                                                AppIcon.s10(
                                                  theme.icons.characters.zap,
                                                  gradient: theme.colors.gold,
                                                ),
                                                const AppGap.s6(),
                                                AppAmount(
                                                  widget.cashuZap.amount
                                                      .toDouble(),
                                                  level: AppTextLevel.bold12,
                                                  color: theme.colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  const AppGap.s2(),
                                  AppShortTextRenderer(
                                    content: widget.cashuZap.event.content,
                                    onResolveEvent: widget.onResolveEvent,
                                    onResolveProfile: widget.onResolveProfile,
                                    onResolveEmoji: widget.onResolveEmoji,
                                    onResolveHashtag: widget.onResolveHashtag,
                                    onLinkTap: widget.onLinkTap,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!widget.isOutgoing) const AppGap.s32(),
      ],
    );
  }
}
