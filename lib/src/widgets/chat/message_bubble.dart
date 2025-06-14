import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class MessageBubbleScope extends InheritedWidget {
  final bool isOutgoing;

  const MessageBubbleScope({
    super.key,
    required super.child,
    required this.isOutgoing,
  });

  static (bool exists, bool isOutgoing) of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<MessageBubbleScope>();
    return (scope != null, scope?.isOutgoing ?? false);
  }

  @override
  bool updateShouldNotify(MessageBubbleScope oldWidget) =>
      oldWidget.isOutgoing != isOutgoing;
}

class AppMessageBubble extends StatefulWidget {
  final ChatMessage? message;
  final Comment? comment;
  final bool showHeader;
  final bool isLastInStack;
  final bool isOutgoing;
  final Function(Model)? onSendAgain;
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

  const AppMessageBubble({
    super.key,
    this.message,
    this.comment,
    this.showHeader = false,
    this.isLastInStack = false,
    this.isOutgoing = false,
    this.onSendAgain,
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
  State<AppMessageBubble> createState() => _AppMessageBubbleState();
}

class _AppMessageBubbleState extends State<AppMessageBubble> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    // Analyze content type
    final contentType = AppShortTextRenderer.analyzeContent(
        widget.message != null
            ? widget.message!.content
            : widget.comment!.content);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ShortTextContent(
          contentType: contentType,
          child: AppSwipeContainer(
            isTransparent: (contentType.isSingleContent) ? true : false,
            decoration: BoxDecoration(
              color: contentType.isSingleContent
                  ? null
                  : (isInsideModal
                      ? theme.colors.white16
                      : theme.colors.gray66),
              gradient: contentType.isSingleContent
                  ? null
                  : widget.isOutgoing
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
            onSwipeLeft: () => widget.onReply(
                widget.message != null ? widget.message! : widget.comment!),
            onSwipeRight: () => widget.onActions(
                widget.message != null ? widget.message! : widget.comment!),
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
                        padding: contentType.isSingleContent
                            ? const AppEdgeInsets.all(AppGapSize.none)
                            : const AppEdgeInsets.only(
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
                                if (widget.showHeader &&
                                    !widget.isOutgoing) ...[
                                  AppContainer(
                                    padding: const AppEdgeInsets.only(
                                      left: AppGapSize.s4,
                                      right: AppGapSize.s4,
                                      top: AppGapSize.s4,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        AppText.bold12(
                                          widget.message != null
                                              ? widget.message!.author.value!
                                                      .name ??
                                                  formatNpub(widget.message!
                                                      .author.value!.pubkey)
                                              : widget.comment!.author.value!
                                                      .name ??
                                                  formatNpub(widget.comment!
                                                      .author.value!.pubkey),
                                          color: Color(npubToColor(
                                              widget.message != null
                                                  ? widget.message!.author
                                                      .value!.pubkey
                                                  : widget.comment!.author
                                                      .value!.pubkey)),
                                          textOverflow: TextOverflow.ellipsis,
                                        ),
                                        AppText.reg12(
                                          TimestampFormatter.format(
                                              widget.message != null
                                                  ? widget.message!.createdAt
                                                  : widget.comment!.createdAt,
                                              format: TimestampFormat.relative),
                                          color: theme.colors.white33,
                                        ),
                                        if (ShortTextContent.of(context) ==
                                            ShortTextContentType
                                                .singleImageStack)
                                          const AppGap.s56(),
                                      ],
                                    ),
                                  ),
                                ],
                                if (!widget.showHeader) const AppGap.s2(),
                                if (contentType.isSingleContent)
                                  const AppGap.s4(),
                                AppShortTextRenderer(
                                  content: widget.message != null
                                      ? widget.message!.content
                                      : widget.comment!.content,
                                  onResolveEvent: widget.onResolveEvent,
                                  onResolveProfile: widget.onResolveProfile,
                                  onResolveEmoji: widget.onResolveEmoji,
                                  onResolveHashtag: widget.onResolveHashtag,
                                  onLinkTap: widget.onLinkTap,
                                  onProfileTap: widget.onProfileTap,
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
                            if (widget.onSendAgain != null) ...[
                              AppContainer(
                                padding: const AppEdgeInsets.symmetric(
                                  horizontal: AppGapSize.s4,
                                  vertical: AppGapSize.s8,
                                ),
                                child: Row(
                                  children: [
                                    AppIcon.s20(
                                      theme.icons.characters.info,
                                      outlineColor: theme.colors.white33,
                                      outlineThickness:
                                          AppLineThicknessData.normal().medium,
                                    ),
                                    const AppGap.s8(),
                                    AppText.reg12(
                                      'Sending Failed',
                                      color: theme.colors.white66,
                                    ),
                                    const AppGap.s4(),
                                    Spacer(),
                                    AppSmallButton(
                                      onTap: () => widget.onSendAgain!(
                                          widget.message != null
                                              ? widget.message!
                                              : widget.comment!),
                                      rounded: true,
                                      inactiveColor: theme.colors.white16,
                                      children: [
                                        AppIcon.s12(
                                          theme.icons.characters.send,
                                          outlineColor: theme.colors.white66,
                                          outlineThickness:
                                              AppLineThicknessData.normal()
                                                  .medium,
                                        ),
                                        const AppGap.s8(),
                                        AppText.reg12(
                                          'Send Again',
                                          color: theme.colors.white66,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (widget.onSendAgain != null)
                              AppContainer(
                                padding: const AppEdgeInsets.symmetric(
                                  horizontal: AppGapSize.s4,
                                  vertical: AppGapSize.s8,
                                ),
                                child: Row(
                                  children: [
                                    AppIcon.s20(
                                      theme.icons.characters.send,
                                      outlineColor: theme.colors.white66,
                                      outlineThickness:
                                          AppLineThicknessData.normal().medium,
                                    ),
                                    const AppGap.s4(),
                                    AppText.reg14(
                                      'Send again',
                                      color: theme.colors.white66,
                                    ),
                                  ],
                                ),
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
        );
      },
    );
  }
}
