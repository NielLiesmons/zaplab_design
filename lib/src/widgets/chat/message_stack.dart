import 'package:zaplab_design/zaplab_design.dart';

class AppMessageStack extends StatelessWidget {
  final String profilePicUrl;
  final List<MessageData> messages;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;

  const AppMessageStack({
    super.key,
    required this.profilePicUrl,
    required this.messages,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppContainer(
          child: AppProfilePic.s32(profilePicUrl),
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
                    eventId: messages[i].eventId,
                    reactions: messages[i].reactions,
                    zaps: messages[i].zaps,
                    onActions: (eventId) =>
                        messages[i].onActions?.call(eventId),
                    onReply: (eventId) => messages[i].onReply?.call(eventId),
                    onReactionTap: (eventId, reactionImageUrl) =>
                        print('React: $eventId with $reactionImageUrl'),
                    onZapTap: (eventId, amount, comment) =>
                        print('Zap: $eventId with $amount sats'),
                    onResolveEvent: onResolveEvent,
                    onResolveProfile: onResolveProfile,
                    onResolveEmoji: onResolveEmoji,
                    onResolveHashtag: onResolveHashtag,
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

class MessageData {
  final String message;
  final String profileName;
  final String eventId;
  final DateTime timestamp;
  final List<Reaction> reactions;
  final List<Zap> zaps;
  final List<QuotedMessage>? quotedMessages;
  final void Function(String)? onReply;
  final void Function(String)? onActions;

  const MessageData({
    required this.message,
    required this.profileName,
    required this.eventId,
    required this.timestamp,
    this.reactions = const [],
    this.zaps = const [],
    this.quotedMessages,
    this.onReply,
    this.onActions,
  });
}
