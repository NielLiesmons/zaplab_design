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
  final List<QuotedMessage>? quotedMessages;
  final void Function(String) onActions;
  final void Function(String) onReply;
  final void Function(String, String)? onReactionTap;
  final void Function(String, int, String?)? onZapTap;

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
    this.quotedMessages,
    required this.onActions,
    required this.onReply,
    this.onReactionTap,
    this.onZapTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    return AppSwipeContainer(
      decoration: BoxDecoration(
        color: isInsideModal ? theme.colors.white16 : theme.colors.grey66,
        borderRadius: BorderRadius.only(
          topLeft: theme.radius.rad16,
          topRight: theme.radius.rad16,
          bottomRight: theme.radius.rad16,
          bottomLeft: isLastInStack ? theme.radius.rad4 : theme.radius.rad16,
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
        child: IntrinsicWidth(
          child: AppContainer(
            padding: const AppEdgeInsets.symmetric(
              horizontal: AppGapSize.s8,
              vertical: AppGapSize.s8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppContainer(
                  padding: const AppEdgeInsets.symmetric(
                    horizontal: AppGapSize.s4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (showHeader) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (profileName != null)
                              AppText.bold12(
                                profileName!,
                                color: theme.colors.white66,
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
                      ],
                      const AppGap.s2(),
                      AppShortTextRenderer(
                        content: message,
                      ),
                    ],
                  ),
                ),
                if (zaps.isNotEmpty || reactions.isNotEmpty) ...[
                  const AppGap.s8(),
                  AppInteractionPills(
                    eventId: eventId,
                    zaps: zaps,
                    reactions: reactions,
                    onZapTap: onZapTap,
                    onReactionTap: onReactionTap,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
