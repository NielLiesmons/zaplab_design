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

class LabMessageBubble extends StatefulWidget {
  final ChatMessage? message;
  final Comment? reply;
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

  const LabMessageBubble({
    super.key,
    this.message,
    this.reply,
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
  State<LabMessageBubble> createState() => _LabMessageBubbleState();
}

class _LabMessageBubbleState extends State<LabMessageBubble> {
  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    // Analyze content type
    final contentType = LabShortTextRenderer.analyzeContent(
        widget.message != null
            ? widget.message!.content
            : widget.reply!.content);

    final isLight = theme.colors.white != const Color(0xFFFFFFFF);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ShortTextContent(
          contentType: contentType,
          child: LabSwipeContainer(
            isTransparent: (contentType.isSingleContent) ? true : false,
            decoration: BoxDecoration(
              color: contentType.isSingleContent
                  ? null
                  : (isInsideModal ? theme.colors.white8 : theme.colors.gray66),
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
            onSwipeLeft: () => widget.onReply(
                widget.message != null ? widget.message! : widget.reply!),
            onSwipeRight: () => widget.onActions(
                widget.message != null ? widget.message! : widget.reply!),
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
                        padding: contentType.isSingleContent
                            ? const LabEdgeInsets.all(LabGapSize.none)
                            : const LabEdgeInsets.only(
                                left: LabGapSize.s8,
                                right: LabGapSize.s8,
                                top: LabGapSize.s4,
                                bottom: LabGapSize.s2,
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
                                  LabContainer(
                                    padding: const LabEdgeInsets.only(
                                      left: LabGapSize.s4,
                                      right: LabGapSize.s4,
                                      top: LabGapSize.s4,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            LabText.bold12(
                                              widget.message != null
                                                  ? widget.message!.author
                                                          .value!.name ??
                                                      formatNpub(widget.message!
                                                          .author.value!.pubkey)
                                                  : widget.reply!.author.value!
                                                          .name ??
                                                      formatNpub(widget
                                                          .reply!
                                                          .author
                                                          .value!
                                                          .pubkey),
                                              color: Color(npubToColor(
                                                  widget.message != null
                                                      ? widget.message!.author
                                                          .value!.pubkey
                                                      : widget.reply!.author
                                                          .value!.pubkey)),
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                            LabText.bold12(
                                              widget.message != null
                                                  ? widget.message!.author
                                                          .value!.name ??
                                                      formatNpub(widget.message!
                                                          .author.value!.pubkey)
                                                  : widget.reply!.author.value!
                                                          .name ??
                                                      formatNpub(widget
                                                          .reply!
                                                          .author
                                                          .value!
                                                          .pubkey),
                                              color: isLight
                                                  ? theme.colors.white33
                                                  : const Color(0x00000000),
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        const LabGap.s12(),
                                        LabText.reg12(
                                          TimestampFormatter.format(
                                              widget.message != null
                                                  ? widget.message!.createdAt
                                                  : widget.reply!.createdAt,
                                              format: TimestampFormat.relative),
                                          color: theme.colors.white33,
                                        ),
                                        if (ShortTextContent.of(context) ==
                                            ShortTextContentType
                                                .singleImageStack)
                                          const LabGap.s56(),
                                      ],
                                    ),
                                  ),
                                ],
                                if (!widget.showHeader) const LabGap.s2(),
                                if (contentType.isSingleContent)
                                  const LabGap.s4(),
                                LabShortTextRenderer(
                                  model: widget.message != null
                                      ? widget.message!
                                      : widget.reply!,
                                  content: widget.message != null
                                      ? widget.message!.content
                                      : widget.reply!.content,
                                  onResolveEvent: widget.onResolveEvent,
                                  onResolveProfile: widget.onResolveProfile,
                                  onResolveEmoji: widget.onResolveEmoji,
                                  onResolveHashtag: widget.onResolveHashtag,
                                  onLinkTap: widget.onLinkTap,
                                  onProfileTap: widget.onProfileTap,
                                ),
                              ],
                            ),
                            // TODO: Unreply and implement once HasMany is available
                            /*
                            if (widget.message.zaps.isNotEmpty ||
                                widget.message.reactions.isNotEmpty) ...[
                              const LabGap.s2(),
                              LabContainer(
                                padding: contentType.isSingleContent
                                    ? const LabEdgeInsets.symmetric(
                                        horizontal: LabGapSize.s8,
                                        vertical: LabGapSize.s8,
                                      )
                                    : const LabEdgeInsets.all(LabGapSize.none),
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
                                child: LabInteractionPills(
                                  nevent: widget.message.id,
                                  zaps: const [],
                                  reactions: const [],
                                  onZapTap: widget.onZapTap,
                                  onReactionTap: widget.onReactionTap,
                                ),
                              ),
                              !contentType.isSingleContent
                                  ? const LabGap.s6()
                                  : const SizedBox.shrink(),
                            ],
                            */
                            if (widget.onSendAgain != null) ...[
                              LabContainer(
                                padding: const LabEdgeInsets.symmetric(
                                  horizontal: LabGapSize.s4,
                                  vertical: LabGapSize.s8,
                                ),
                                child: Row(
                                  children: [
                                    LabIcon.s20(
                                      theme.icons.characters.info,
                                      outlineColor: theme.colors.white33,
                                      outlineThickness:
                                          LabLineThicknessData.normal().medium,
                                    ),
                                    const LabGap.s8(),
                                    LabText.reg12(
                                      'Sending Failed',
                                      color: theme.colors.white66,
                                    ),
                                    const LabGap.s4(),
                                    Spacer(),
                                    LabSmallButton(
                                      onTap: () => widget.onSendAgain!(
                                          widget.message != null
                                              ? widget.message!
                                              : widget.reply!),
                                      rounded: true,
                                      color: theme.colors.white16,
                                      children: [
                                        LabIcon.s12(
                                          theme.icons.characters.send,
                                          outlineColor: theme.colors.white66,
                                          outlineThickness:
                                              LabLineThicknessData.normal()
                                                  .medium,
                                        ),
                                        const LabGap.s8(),
                                        LabText.reg12(
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
                              LabContainer(
                                padding: const LabEdgeInsets.symmetric(
                                  horizontal: LabGapSize.s4,
                                  vertical: LabGapSize.s8,
                                ),
                                child: Row(
                                  children: [
                                    LabIcon.s20(
                                      theme.icons.characters.send,
                                      outlineColor: theme.colors.white66,
                                      outlineThickness:
                                          LabLineThicknessData.normal().medium,
                                    ),
                                    const LabGap.s4(),
                                    LabText.reg14(
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
