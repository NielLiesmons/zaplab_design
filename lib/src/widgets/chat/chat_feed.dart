import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppChatFeed extends StatelessWidget {
  final List<ChatMessage> messages;
  final String currentPubkey;
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
    required this.currentPubkey,
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
    String? currentPubkey;
    DateTime? lastMessageTime;

    for (final message in messages) {
      final shouldStartNewGroup = currentGroup == null ||
          currentPubkey != message.author.value?.pubkey ||
          lastMessageTime!.difference(message.createdAt).inMinutes.abs() > 21;

      if (shouldStartNewGroup) {
        currentGroup = [message];
        groups.add(currentGroup);
        currentPubkey = message.author.value?.pubkey;
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
                  isOutgoing: group.first.author.value?.pubkey == currentPubkey,
                  onReply: onReply,
                  onActions: onActions,
                  onReactionTap: onReactionTap,
                  onZapTap: onZapTap,
                  onLinkTap: onLinkTap,
                ),
                const AppGap.s8(),
              ],
            ),
          const AppGap.s8(),
        ],
      ),
    );
  }
}
