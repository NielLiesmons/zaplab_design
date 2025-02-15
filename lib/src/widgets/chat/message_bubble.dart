import 'package:zaplab_design/zaplab_design.dart';
import 'package:zaplab_design/src/utils/timestamp_formatter.dart';

class MessageBubbleScope extends InheritedWidget {
  const MessageBubbleScope({
    super.key,
    required super.child,
  });

  static bool of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MessageBubbleScope>() !=
        null;
  }

  @override
  bool updateShouldNotify(MessageBubbleScope oldWidget) => false;
}

class AppMessageBubble extends StatelessWidget {
  final String message;
  final String? profileName;
  final DateTime? timestamp;
  final bool showHeader;
  final bool isLastInStack;
  final String eventId;
  final List<Reaction> reactions;
  final List<Zap> zaps;
  final void Function(String) onActions;
  final void Function(String) onReply;
  final void Function(String, String)? onReactionTap;
  final void Function(String, int, String?)? onZapTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  const AppMessageBubble({
    super.key,
    required this.message,
    required this.eventId,
    this.profileName,
    this.timestamp,
    this.showHeader = false,
    this.isLastInStack = false,
    this.reactions = const [],
    this.zaps = const [],
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
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return AppSwipeContainer(
          decoration: BoxDecoration(
            color: isInsideModal ? theme.colors.white16 : theme.colors.grey66,
            borderRadius: BorderRadius.only(
              topLeft: theme.radius.rad16,
              topRight: theme.radius.rad16,
              bottomRight: theme.radius.rad16,
              bottomLeft:
                  isLastInStack ? theme.radius.rad4 : theme.radius.rad16,
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
          onSwipeLeft: () => onActions(eventId),
          onSwipeRight: () => onReply(eventId),
          child: MessageBubbleScope(
            child: LayoutBuilder(
              builder: (context, bubbleConstraints) {
                return IntrinsicWidth(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: bubbleConstraints.maxWidth,
                      minWidth: 104,
                    ),
                    child: AppContainer(
                      padding: const AppEdgeInsets.only(
                        left: AppGapSize.s8,
                        right: AppGapSize.s8,
                        top: AppGapSize.s4,
                        bottom: AppGapSize.s2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (showHeader) ...[
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
                                      if (profileName != null)
                                        AppText.bold12(
                                          profileName!,
                                          color: theme.colors.white66,
                                          textOverflow: TextOverflow.ellipsis,
                                        ),
                                      if (timestamp != null) ...[
                                        const AppGap.s8(),
                                        AppText.reg12(
                                          TimestampFormatter.format(timestamp!,
                                              format: TimestampFormat.relative),
                                          color: theme.colors.white33,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                              if (!showHeader) const AppGap.s2(),
                              AppShortTextRenderer(
                                content: message,
                                onResolveEvent: onResolveEvent,
                                onResolveProfile: onResolveProfile,
                                onResolveEmoji: onResolveEmoji,
                                onResolveHashtag: onResolveHashtag,
                                onLinkTap: onLinkTap,
                              ),
                            ],
                          ),
                          if (zaps.isNotEmpty || reactions.isNotEmpty) ...[
                            const AppGap.s2(),
                            AppInteractionPills(
                              eventId: eventId,
                              zaps: zaps,
                              reactions: reactions,
                              onZapTap: onZapTap,
                              onReactionTap: onReactionTap,
                            ),
                            const AppGap.s6(),
                          ],
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
