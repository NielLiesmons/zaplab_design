import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppMessageStack extends StatelessWidget {
  final List<ChatMessage>? messages;
  final List<Comment>? comments;
  final bool isOutgoing;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final Function(Model) onActions;
  final Function(Model) onReply;
  final Function(Reaction) onReactionTap;
  final Function(Zap) onZapTap;
  final Function(Profile) onProfileTap;

  const AppMessageStack({
    super.key,
    this.messages,
    this.comments,
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
    required this.onProfileTap,
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
                messages != null
                    ? messages!.first.author.value
                    : comments!.first.author.value,
                onTap: () => onProfileTap(messages != null
                    ? messages!.first.author.value as Profile
                    : comments!.first.author.value as Profile)),
          ),
          const AppGap.s4(),
        ] else ...[
          if (isOutgoing &&
              AppShortTextRenderer.analyzeContent(messages != null
                      ? messages!.first.content
                      : comments!.first.content) !=
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
                for (int i = 0;
                    i <
                        (messages != null
                            ? messages!.length
                            : comments!.length);
                    i++) ...[
                  if (i > 0) const AppGap.s2(),
                  AppMessageBubble(
                    message: messages != null ? messages![i] : null,
                    comment: comments != null ? comments![i] : null,
                    showHeader:
                        i == 0 && !isOutgoing, // Only show header for incoming
                    isLastInStack: i ==
                        (messages != null
                                ? messages!.length
                                : comments!.length) -
                            1,
                    isOutgoing: isOutgoing,
                    onActions: onActions,
                    onReply: onReply,
                    onReactionTap: onReactionTap,
                    onZapTap: onZapTap,
                    onResolveEvent: onResolveEvent,
                    onResolveProfile: onResolveProfile,
                    onResolveEmoji: onResolveEmoji,
                    onResolveHashtag: onResolveHashtag,
                    onLinkTap: onLinkTap,
                    onProfileTap: onProfileTap,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (!isOutgoing &&
            AppShortTextRenderer.analyzeContent(messages != null
                    ? messages!.first.content
                    : comments!.first.content) !=
                ShortTextContentType.singleImageStack)
          const AppGap.s32(),
      ],
    );
  }
}
