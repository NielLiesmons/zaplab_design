import 'package:zaplab_design/zaplab_design.dart';

class AppMessageStack extends StatelessWidget {
  final List<Message> messages;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final void Function(String) onReply;
  final void Function(String) onReactionTap;
  final void Function(String) onZapTap;

  const AppMessageStack({
    super.key,
    required this.messages,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    required this.onReply,
    required this.onReactionTap,
    required this.onZapTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppContainer(
          child: AppProfilePic.s32(messages.first.profilePicUrl),
        ),
        const AppGap.s4(),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < messages.length; i++) ...[
                  if (i > 0) const AppGap.s2(),
                  AppMessageBubble(
                    message: messages[i].message,
                    profileName: messages[i].profileName,
                    timestamp: messages[i].timestamp,
                    showHeader: i == 0,
                    isLastInStack: i == messages.length - 1,
                    nevent: messages[i].nevent,
                    reactions: messages[i].reactions,
                    zaps: messages[i].zaps,
                    onActions: (context, nevent) => AppActionsModal.show(
                      context,
                      profileName: messages[i].profileName,
                      eventId: nevent,
                      contentType: 'message',
                      profilePicUrl: messages[i].profilePicUrl,
                      message: messages[i].message,
                      recentAmounts: const [],
                      recentReactions: const [],
                    ),
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
        const AppGap.s32(),
      ],
    );
  }
}
