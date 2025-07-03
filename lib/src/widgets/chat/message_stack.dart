import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabMessageStack extends StatelessWidget {
  final List<ChatMessage>? messages;
  final List<Comment>? replies;
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

  const LabMessageStack({
    super.key,
    this.messages,
    this.replies,
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
    return LabContainer(
      padding: const LabEdgeInsets.symmetric(
        horizontal: LabGapSize.s8,
      ),
      child: Row(
        mainAxisAlignment: isOutgoing
            ? MainAxisAlignment.end // Outgoing messages aligned right
            : MainAxisAlignment.start, // Incoming messages aligned left
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOutgoing) ...[
            LabContainer(
              child: LabProfilePic.s32(
                  messages != null
                      ? messages!.first.author.value
                      : replies!.first.author.value,
                  onTap: () => onProfileTap(messages != null
                      ? messages!.first.author.value as Profile
                      : replies!.first.author.value as Profile)),
            ),
            const LabGap.s4(),
          ] else ...[
            if (isOutgoing &&
                LabShortTextRenderer.analyzeContent(messages != null
                        ? messages!.first.content
                        : replies!.first.content) !=
                    ShortTextContentType.singleImageStack)
              const LabGap.s64(),
            const LabGap.s4(),
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
                              : replies!.length);
                      i++) ...[
                    if (i > 0) const LabGap.s2(),
                    LabMessageBubble(
                      message: messages != null ? messages![i] : null,
                      reply: replies != null ? replies![i] : null,
                      showHeader: i == 0 &&
                          !isOutgoing, // Only show header for incoming
                      isLastInStack: i ==
                          (messages != null
                                  ? messages!.length
                                  : replies!.length) -
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
              LabShortTextRenderer.analyzeContent(messages != null
                      ? messages!.first.content
                      : replies!.first.content) !=
                  ShortTextContentType.singleImageStack)
            const LabGap.s32(),
        ],
      ),
    );
  }
}
