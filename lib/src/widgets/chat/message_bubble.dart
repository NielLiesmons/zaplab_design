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
  final bool isFirstInStack;
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
  final bool showParentReply;
  final bool isPublishing;
  final String? activePubkey;

  const LabMessageBubble({
    super.key,
    this.message,
    this.reply,
    this.isFirstInStack = false,
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
    this.showParentReply = false,
    this.isPublishing = false,
    this.activePubkey,
  });

  @override
  State<LabMessageBubble> createState() => _LabMessageBubbleState();
}

class _LabMessageBubbleState extends State<LabMessageBubble> {
  // Cache expensive operations
  ShortTextContentType? _cachedContentType;
  String? _lastContent;
  bool? _lastIsOutgoing;
  bool? _lastIsFirstInStack;
  bool? _lastIsLastInStack;

  // Cache theme-dependent values
  LabThemeData? _cachedTheme;
  BoxDecoration? _cachedContainerDecoration;
  BorderRadius? _cachedBorderRadius;

  // Performance tracking
  int _buildCount = 0;
  DateTime? _lastBuildTime;

  // Performance debug flags - set to true only when debugging
  static const bool _debugRebuilds = false;
  static const bool _debugCacheMisses = false;

  // Performance thresholds - only log when performance is actually bad
  static const int _rebuildThresholdMs = 50; // Log rebuilds faster than 50ms

  @override
  Widget build(BuildContext context) {
    // Performance debugging
    _buildCount++;
    final now = DateTime.now();
    if (_debugRebuilds && _lastBuildTime != null) {
      final timeSinceLastBuild = now.difference(_lastBuildTime!);
      if (timeSinceLastBuild.inMilliseconds < _rebuildThresholdMs) {
        print(
            '🚨 FAST REBUILD: Message ${widget.message?.id ?? widget.reply?.id} rebuilt in ${timeSinceLastBuild.inMilliseconds}ms (build #$_buildCount)');
      }
    }
    _lastBuildTime = now;

    // Cache theme access
    final theme = LabTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    // Analyze content type (with trimmed content for quoted messages)
    String contentToAnalyze = widget.message != null
        ? widget.message!.content
        : widget.reply!.content;

    // Trim quoted message URI if it exists
    if (widget.message != null && widget.message!.quotedMessage.value != null) {
      try {
        final nostrUriMatch =
            RegExp(r'nostr:nevent1[a-zA-Z0-9]+').firstMatch(contentToAnalyze);
        if (nostrUriMatch != null) {
          final quotedUri = nostrUriMatch.group(0)!;
          if (contentToAnalyze.startsWith(quotedUri)) {
            contentToAnalyze =
                contentToAnalyze.substring(quotedUri.length).trim();
            contentToAnalyze =
                contentToAnalyze.replaceFirst(RegExp(r'^[\r\n]+'), '');
          }
        }
      } catch (e) {
        print('Failed to trim quoted message URI for content analysis: $e');
      }
    }

    // Cache content analysis - only recalculate if content or outgoing status changes
    if (_cachedContentType == null ||
        _lastContent != contentToAnalyze ||
        _lastIsOutgoing != widget.isOutgoing ||
        _lastIsFirstInStack != widget.isFirstInStack ||
        _lastIsLastInStack != widget.isLastInStack) {
      _cachedContentType =
          LabShortTextRenderer.analyzeContent(contentToAnalyze);
      _lastContent = contentToAnalyze;
      _lastIsOutgoing = widget.isOutgoing;
      _lastIsFirstInStack = widget.isFirstInStack;
      _lastIsLastInStack = widget.isLastInStack;

      if (_debugCacheMisses) {
        print(
            '🔄 Content analysis cache miss for message ${widget.message?.id ?? widget.reply?.id}');
      }
    }

    final contentType = _cachedContentType!;

    // Cache expensive calculations
    final isLight = theme.colors.white != const Color(0xFFFFFFFF);

    return LabContainer(
      padding: LabEdgeInsets.only(
        left: LabGapSize.s8,
        right: LabGapSize.s8,
        top: widget.isFirstInStack ? LabGapSize.s8 : LabGapSize.s2,
      ),
      child: Row(
        mainAxisAlignment: widget.isOutgoing
            ? MainAxisAlignment.end // Outgoing messages aligned right
            : MainAxisAlignment.start, // Incoming messages aligned left
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!widget.isOutgoing) ...[
            widget.isLastInStack
                ? LabContainer(
                    child: LabProfilePic.s32(
                        widget.message != null
                            ? widget.message!.author.value
                            : widget.reply!.author.value,
                        onTap: () => widget.onProfileTap(widget.message != null
                            ? widget.message!.author.value as Profile
                            : widget.reply!.author.value as Profile)),
                  )
                : const LabGap.s32(),
            const LabGap.s4(),
          ] else if (widget.isOutgoing) ...[
            if (widget.isOutgoing &&
                contentType != ShortTextContentType.singleImageStack)
              const LabGap.s64(),
            const LabGap.s4(),
          ],
          Flexible(
            child: ShortTextContent(
              contentType: contentType,
              child: IntrinsicWidth(
                child: LabSwipeContainer(
                  isTransparent: (contentType.isSingleContent) ? true : false,
                  decoration: BoxDecoration(
                    color: contentType.isSingleContent
                        ? null
                        : (isInsideModal
                            ? theme.colors.white8
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
                    child: IntrinsicWidth(
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
                                if (widget.isFirstInStack &&
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
                                                              .value !=
                                                          null
                                                      ? widget.message!.author
                                                              .value?.name ??
                                                          formatNpub(widget
                                                                  .message!
                                                                  .author
                                                                  .value
                                                                  ?.npub ??
                                                              '')
                                                      : 'Profile...'
                                                  : widget.reply!.author
                                                              .value !=
                                                          null
                                                      ? widget.reply!.author
                                                              .value?.name ??
                                                          formatNpub(widget
                                                                  .reply!
                                                                  .author
                                                                  .value
                                                                  ?.npub ??
                                                              '')
                                                      : 'Profile...',
                                              color: Color(
                                                npubToColor(
                                                    widget.message != null
                                                        ? widget.message!.author
                                                                .value?.npub ??
                                                            ''
                                                        : widget.reply!.author
                                                                .value?.npub ??
                                                            ''),
                                              ),
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                            LabText.bold12(
                                              widget.message != null
                                                  ? widget.message!.author.value
                                                          ?.name ??
                                                      formatNpub(widget
                                                              .message!
                                                              .author
                                                              .value
                                                              ?.npub ??
                                                          'Profile...')
                                                  : widget.reply!.author.value
                                                          ?.name ??
                                                      formatNpub(widget
                                                              .reply!
                                                              .author
                                                              .value
                                                              ?.npub ??
                                                          'Profile...'),
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

                                Builder(
                                  builder: (context) {
                                    bool hasQuotedMessage = false;
                                    bool hasParentReply = false;

                                    try {
                                      if (widget.message != null) {
                                        final quotedMessage =
                                            widget.message!.quotedMessage.value;
                                        hasQuotedMessage =
                                            quotedMessage != null;
                                      }
                                    } catch (e) {
                                      print(
                                          'Failed to access quoted message: $e');
                                    }

                                    try {
                                      if (widget.reply != null) {
                                        final parentModel =
                                            widget.reply!.parentModel.value;
                                        hasParentReply = parentModel != null;
                                      }
                                    } catch (e) {
                                      print(
                                          'Failed to access parent model: $e');
                                    }

                                    if (hasQuotedMessage || hasParentReply) {
                                      return const LabGap.s4();
                                    } else {
                                      return const LabGap.s2();
                                    }
                                  },
                                ),
                                if (contentType.isSingleContent)
                                  const LabGap.s4(),
                                // Show quoted message if it exists and isn't already in content
                                Builder(
                                  builder: (context) {
                                    try {
                                      if (widget.message != null &&
                                          widget.message!.quotedMessage.value !=
                                              null &&
                                          widget.message!.quotedMessage.value
                                              is ChatMessage) {
                                        // Check if the content contains a nostr:nevent1 URI
                                        final content = widget.message!.content;
                                        final hasNostrUri =
                                            content.contains('nostr:nevent1');

                                        // Show quoted message if there's a URI in content OR if there's a quoted message relationship
                                        if (hasNostrUri ||
                                            widget.message!.quotedMessage
                                                    .value !=
                                                null) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              LabQuotedMessage(
                                                chatMessage: widget.message!
                                                    .quotedMessage.value,
                                                onResolveEvent:
                                                    widget.onResolveEvent,
                                                onResolveProfile:
                                                    widget.onResolveProfile,
                                                onResolveEmoji:
                                                    widget.onResolveEmoji,
                                                onTap: (model) =>
                                                    widget.onReply(model),
                                              ),
                                              const LabGap.s4(),
                                            ],
                                          );
                                        }
                                      }
                                    } catch (e) {
                                      print(
                                          'Failed to render quoted message: $e');
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                // Show parent reply if enabled and exists
                                if (widget.showParentReply &&
                                    widget.reply != null &&
                                    widget.reply!.parentModel.value != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LabQuotedMessage(
                                        reply: widget.reply!.parentModel.value
                                            as Comment,
                                        onResolveEvent: widget.onResolveEvent,
                                        onResolveProfile:
                                            widget.onResolveProfile,
                                        onResolveEmoji: widget.onResolveEmoji,
                                        onTap: (model) => widget.onReply(model),
                                      ),
                                      const LabGap.s4(),
                                    ],
                                  ),
                                Builder(
                                  builder: (context) {
                                    // Trim quoted message URI from content if it exists
                                    String contentToRender =
                                        widget.message != null
                                            ? widget.message!.content
                                            : widget.reply!.content;

                                    try {
                                      if (widget.message != null &&
                                          widget.message!.quotedMessage.value !=
                                              null) {
                                        // Look for nostr:nevent1 URI in the content
                                        final content = widget.message!.content;
                                        final nostrUriMatch =
                                            RegExp(r'nostr:nevent1[a-zA-Z0-9]+')
                                                .firstMatch(content);

                                        if (nostrUriMatch != null) {
                                          final quotedUri =
                                              nostrUriMatch.group(0)!;
                                          if (content.startsWith(quotedUri)) {
                                            // Remove the URI and any following whitespace/newlines
                                            contentToRender = content
                                                .substring(quotedUri.length)
                                                .trim();
                                            // Remove leading newline/line break if present
                                            contentToRender =
                                                contentToRender.replaceFirst(
                                                    RegExp(r'^[\r\n]+'), '');
                                          }
                                        }
                                      }
                                    } catch (e) {
                                      print(
                                          'Failed to trim quoted message URI: $e');
                                    }

                                    final renderer = LabShortTextRenderer(
                                      model: widget.message != null
                                          ? widget.message!
                                          : widget.reply!,
                                      content: contentToRender,
                                      onResolveEvent: widget.onResolveEvent,
                                      onResolveProfile: widget.onResolveProfile,
                                      onResolveEmoji: widget.onResolveEmoji,
                                      onResolveHashtag: widget.onResolveHashtag,
                                      onLinkTap: widget.onLinkTap,
                                      onProfileTap: widget.onProfileTap,
                                    );

                                    return renderer;
                                  },
                                ),
                              ],
                            ),
                            // Reactions and Zaps
                            if (widget.message?.reactions.length != 0 ||
                                widget.message?.zaps.length != 0) ...[
                              LabContainer(
                                padding: const LabEdgeInsets.only(
                                  bottom: LabGapSize.s4,
                                ),
                                child: LabInteractionPills(
                                  zaps: widget.message!.zaps.toList(),
                                  reactions: widget.message!.reactions.toList(),
                                  onZapTap: widget.onZapTap,
                                  onReactionTap: widget.onReactionTap,
                                  activePubkey: widget.activePubkey,
                                ),
                              ),
                            ],
                            if (widget.isPublishing) ...[
                              const LabContainer(
                                padding: LabEdgeInsets.symmetric(
                                  horizontal: LabGapSize.s4,
                                  vertical: LabGapSize.s8,
                                ),
                                child: LabProgressBar(
                                  progress: 0.5,
                                ),
                              ),
                            ] else if (widget.onSendAgain != null) ...[
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
                                    const Spacer(),
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
                                          color: theme.colors.whiteEnforced,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (!widget.isOutgoing &&
              contentType != ShortTextContentType.singleImageStack)
            const LabGap.s32(),
        ],
      ),
    );
  }
}
