import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppMessageStack extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isOutgoing;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final void Function(String) onActions;
  final void Function(String) onReply;
  final void Function(String) onReactionTap;
  final void Function(String) onZapTap;
  final bool isTyping;

  const AppMessageStack({
    super.key,
    required this.messages,
    this.isOutgoing = false,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    required this.onActions,
    required this.onReply,
    required this.onReactionTap,
    required this.onZapTap,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isOutgoing
          ? MainAxisAlignment.end // Outgoing messages aligned right
          : MainAxisAlignment.start, // Incoming messages aligned left
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isOutgoing) ...[
          AppContainer(
            child: AppProfilePic.s32(
                messages.first.author.value?.pictureUrl ?? ''),
          ),
          const AppGap.s4(),
        ] else ...[
          if (!isOutgoing &&
              AppShortTextRenderer.analyzeContent(messages.first.content) !=
                  ShortTextContentType.singleImageStack)
            const AppGap.s64(),
          const AppGap.s4(),
        ],
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 28),
            child: Column(
              crossAxisAlignment: isOutgoing
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < messages.length; i++) ...[
                  if (i > 0) const AppGap.s2(),
                  AppMessageBubble(
                    message: messages[i],
                    showHeader:
                        i == 0 && !isOutgoing, // Only show header for incoming
                    isLastInStack: i == messages.length - 1,
                    isOutgoing: isOutgoing,
                    isTyping: isTyping && i == messages.length - 1,
                    onActions: onActions,
                    onReply: onReply,
                    onReactionTap: onReactionTap,
                    onZapTap: onZapTap,
                    onResolveEvent: onResolveEvent,
                    onResolveProfile: onResolveProfile,
                    onResolveEmoji: onResolveEmoji,
                    onResolveHashtag: onResolveHashtag,
                    onLinkTap: onLinkTap,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (!isOutgoing &&
            AppShortTextRenderer.analyzeContent(messages.first.content) !=
                ShortTextContentType.singleImageStack)
          const AppGap.s32(),
      ],
    );
  }
}
