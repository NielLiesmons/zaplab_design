import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabZapBubble extends StatefulWidget {
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
  final Function(Profile) onProfileTap;

  const LabZapBubble({
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
    required this.onProfileTap,
  });

  @override
  State<LabZapBubble> createState() => _LabZapBubbleState();
}

class _LabZapBubbleState extends State<LabZapBubble> {
  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isLight = theme.colors.white != const Color(0xFFFFFFFF);

    return LabContainer(
      padding: const LabEdgeInsets.symmetric(
        horizontal: LabGapSize.s8,
      ),
      child: Row(
        mainAxisAlignment: widget.isOutgoing
            ? MainAxisAlignment.end // Outgoing zaps aligned right
            : MainAxisAlignment.start, // Incoming zaps aligned left
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!widget.isOutgoing) ...[
            LabContainer(
              child: LabProfilePic.s32(widget.cashuZap.author.value,
                  onTap: () => widget
                      .onProfileTap(widget.cashuZap.author.value as Profile)),
            ),
            const LabGap.s4(),
          ] else ...[
            const LabGap.s64(),
            const LabGap.s4(),
          ],
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 28),
              child: Column(
                crossAxisAlignment: widget.isOutgoing
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  LabSwipeContainer(
                    decoration: BoxDecoration(
                      gradient: theme.colors.gold16,
                      border: Border.all(
                        color: isLight
                            ? theme.colors.goldColor
                            : theme.colors.goldColor66,
                        width: LabLineThicknessData.normal().medium,
                      ),
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
                    leftContent: LabIcon.s16(
                      theme.icons.characters.reply,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LabLineThicknessData.normal().medium,
                    ),
                    rightContent: LabIcon.s10(
                      theme.icons.characters.chevronUp,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LabLineThicknessData.normal().medium,
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
                              child: LabContainer(
                                decoration:
                                    BoxDecoration(color: theme.colors.black16),
                                padding: const LabEdgeInsets.only(
                                  left: LabGapSize.s8,
                                  right: LabGapSize.s8,
                                  top: LabGapSize.s6,
                                  bottom: LabGapSize.s2,
                                ),
                                child: Column(
                                  crossAxisAlignment: widget.isOutgoing
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!widget.isOutgoing) ...[
                                      LabContainer(
                                        padding: const LabEdgeInsets.only(
                                          left: LabGapSize.s4,
                                          right: LabGapSize.s4,
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
                                                    LabText.bold12(
                                                      widget.cashuZap.author
                                                              .value!.name ??
                                                          formatNpub(widget
                                                              .cashuZap
                                                              .author
                                                              .value!
                                                              .pubkey),
                                                      gradient:
                                                          theme.colors.gold,
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    LabText.bold12(
                                                      widget.cashuZap.author
                                                              .value!.name ??
                                                          formatNpub(widget
                                                              .cashuZap
                                                              .author
                                                              .value!
                                                              .pubkey),
                                                      color:
                                                          theme.colors.white8,
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            const LabGap.s4(),
                                            Row(
                                              children: [
                                                Stack(
                                                  children: [
                                                    LabIcon.s12(
                                                      theme
                                                          .icons.characters.zap,
                                                      gradient:
                                                          theme.colors.gold,
                                                    ),
                                                    LabIcon.s12(
                                                      theme
                                                          .icons.characters.zap,
                                                      color:
                                                          theme.colors.white8,
                                                    ),
                                                  ],
                                                ),
                                                const LabGap.s4(),
                                                LabAmount(
                                                  widget.cashuZap.amount
                                                      .toDouble(),
                                                  level: LabTextLevel.bold14,
                                                  color: theme.colors.white,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    const LabGap.s2(),
                                    LabShortTextRenderer(
                                      model: widget.cashuZap,
                                      content: widget.cashuZap.event.content,
                                      onResolveEvent: widget.onResolveEvent,
                                      onResolveProfile: widget.onResolveProfile,
                                      onResolveEmoji: widget.onResolveEmoji,
                                      onResolveHashtag: widget.onResolveHashtag,
                                      onLinkTap: widget.onLinkTap,
                                      onProfileTap: widget.onProfileTap,
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
          if (!widget.isOutgoing) const LabGap.s32(),
        ],
      ),
    );
  }
}
