import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppChatFeed extends StatelessWidget {
  final List<ChatMessage> messages;
  final String currentNpub;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final void Function(String) onActions;
  final void Function(String) onReply;
  final void Function(String) onReactionTap;
  final void Function(String) onZapTap;
  final LinkTapHandler onLinkTap;

  const AppChatFeed({
    super.key,
    required this.messages,
    required this.currentNpub,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onActions,
    required this.onReply,
    required this.onReactionTap,
    required this.onZapTap,
    required this.onLinkTap,
  });

  List<List<ChatMessage>> _groupMessages() {
    final groups = <List<ChatMessage>>[];
    List<ChatMessage>? currentGroup;
    String? currentAuthor;
    DateTime? lastMessageTime;

    for (final message in messages) {
      final shouldStartNewGroup = currentGroup == null ||
          currentAuthor != message.author.value.npub ||
          lastMessageTime!.difference(message.createdAt).inMinutes.abs() > 21;

      if (shouldStartNewGroup) {
        currentGroup = [message];
        groups.add(currentGroup);
        currentAuthor = message.author.value.npub;
      } else {
        currentGroup.add(message);
      }
      lastMessageTime = message.createdAt;
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
                  isOutgoing: group.first.npub == currentNpub,
                  onReply: onReply,
                  onActions: onActions,
                  onReactionTap: onReactionTap,
                  onZapTap: onZapTap,
                  onLinkTap: onLinkTap,
                ),
                const AppGap.s8(),
              ],
            ),
        ],
      ),
    );
  }
}
