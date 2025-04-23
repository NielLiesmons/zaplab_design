import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppZapBubble extends StatefulWidget {
  final Zap zap;
  final bool isOutgoing;
  final Function(Model) onActions;
  final Function(Model) onReply;
  final Function(Reaction)? onReactionTap;
  final Function(Zap)? onZapTap;
  final NostrModelResolver onResolveModel;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;

  const AppZapBubble({
    super.key,
    required this.zap,
    this.isOutgoing = false,
    required this.onActions,
    required this.onReply,
    this.onReactionTap,
    this.onZapTap,
    required this.onResolveModel,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return AppSwipeContainer(
          decoration: BoxDecoration(
            gradient: theme.colors.gold33,
            borderRadius: BorderRadius.only(
              topLeft: theme.radius.rad16,
              topRight: theme.radius.rad16,
              bottomRight:
                  widget.isOutgoing ? theme.radius.rad4 : theme.radius.rad16,
              bottomLeft:
                  !widget.isOutgoing ? theme.radius.rad4 : theme.radius.rad16,
            ),
          ),
          leftContent: AppIcon.s16(
            theme.icons.characters.reply,
            outlineColor: theme.colors.white66,
            outlineThickness: LineThicknessData.normal().medium,
          ),
          rightContent: AppIcon.s10(
            theme.icons.characters.chevronUp,
            outlineColor: theme.colors.white66,
            outlineThickness: LineThicknessData.normal().medium,
          ),
          onSwipeLeft: widget.onReply(widget.zap),
          onSwipeRight: widget.onActions(widget.zap),
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
                        top: AppGapSize.s4,
                        bottom: AppGapSize.s2,
                      ),
                      child: Column(
                        crossAxisAlignment: widget.isOutgoing
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (!widget.isOutgoing) ...[
                                AppContainer(
                                  padding: const AppEdgeInsets.only(
                                    left: AppGapSize.s4,
                                    right: AppGapSize.s4,
                                    // top: AppGapSize.s4,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (widget.zap.author.value != null)
                                        AppText.bold14(
                                          widget.zap.author.value!.name ??
                                              formatNpub(widget
                                                  .zap.author.value!.pubkey),
                                          gradient: theme.colors.gold,
                                          textOverflow: TextOverflow.ellipsis,
                                        ),
                                      AppAmount(
                                        widget.zap.amount.toDouble(),
                                        level: AppTextLevel.bold16,
                                        color: theme.colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const AppGap.s4(),
                              AppShortTextRenderer(
                                content: widget.zap.event.content,
                                onResolveModel: widget.onResolveModel,
                                onResolveProfile: widget.onResolveProfile,
                                onResolveEmoji: widget.onResolveEmoji,
                                onResolveHashtag: widget.onResolveHashtag,
                                onLinkTap: widget.onLinkTap,
                              ),
                            ],
                          ),
                          // TODO: Uncomment and implement once HasMany is available
                          /*
                            if (widget.message.zaps.isNotEmpty ||
                                widget.message.reactions.isNotEmpty) ...[
                              const AppGap.s2(),
                              AppContainer(
                                padding: contentType.isSingleContent
                                    ? const AppEdgeInsets.symmetric(
                                        horizontal: AppGapSize.s8,
                                        vertical: AppGapSize.s8,
                                      )
                                    : const AppEdgeInsets.all(AppGapSize.none),
                                decoration: contentType.isSingleContent
                                    ? BoxDecoration(
                                        color: isInsideModal
                                            ? theme.colors.white16
                                            : theme.colors.grey66,
                                        gradient: widget.isOutgoing
                                            ? theme.colors.blurple66
                                            : null,
                                        borderRadius: BorderRadius.only(
                                          topLeft: theme.radius.rad16,
                                          topRight: theme.radius.rad16,
                                          bottomRight: widget.isOutgoing
                                              ? (widget.isLastInStack
                                                  ? theme.radius.rad4
                                                  : theme.radius.rad16)
                                              : theme.radius.rad16,
                                          bottomLeft: !widget.isOutgoing
                                              ? (widget.isLastInStack
                                                  ? theme.radius.rad4
                                                  : theme.radius.rad16)
                                              : theme.radius.rad16,
                                        ),
                                      )
                                    : null,
                                child: AppInteractionPills(
                                  nevent: widget.message.id,
                                  zaps: const [],
                                  reactions: const [],
                                  onZapTap: widget.onZapTap,
                                  onReactionTap: widget.onReactionTap,
                                ),
                              ),
                              !contentType.isSingleContent
                                  ? const AppGap.s6()
                                  : const SizedBox.shrink(),
                            ],
                            */
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
