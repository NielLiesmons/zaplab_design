import 'package:zaplab_design/zaplab_design.dart';

class AppChatFeed extends StatelessWidget {
  final List<Message> messages;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;

  const AppChatFeed({
    super.key,
    required this.messages,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
  });

  List<List<Message>> _groupMessages() {
    final groups = <List<Message>>[];
    List<Message>? currentGroup;
    String? currentAuthor;
    DateTime? lastMessageTime;

    for (final message in messages) {
      final shouldStartNewGroup = currentGroup == null ||
          currentAuthor != message.profileName ||
          lastMessageTime!.difference(message.timestamp).inMinutes.abs() > 21;

      if (shouldStartNewGroup) {
        currentGroup = [message];
        groups.add(currentGroup);
        currentAuthor = message.profileName;
      } else {
        currentGroup.add(message);
      }
      lastMessageTime = message.timestamp;
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final messageGroups = _groupMessages();

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s6),
      child: Column(
        children: [
          for (final group in messageGroups)
            Column(
              children: [
                AppMessageStack(
                  messages: group,
                  onResolveEvent: onResolveEvent,
                  onResolveProfile: onResolveProfile,
                  onResolveEmoji: onResolveEmoji,
                  onResolveHashtag: onResolveHashtag,
                  onLinkTap: onLinkTap,
                  onReply: (eventId) {}, // Implement these
                  onReactionTap: (eventId) {},
                  onZapTap: (eventId) {},
                ),
                const AppGap.s8(),
              ],
            ),
        ],
      ),
    );
  }
}
