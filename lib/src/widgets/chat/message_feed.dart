import 'package:zaplab_design/zaplab_design.dart';

class AppMessageFeed extends StatefulWidget {
  final List<Message> initialMessages;
  final Stream<Message>? messageStream;
  final Stream<(String messageId, Reaction reaction)>? reactionStream;
  final Stream<(String messageId, Zap zap)>? zapStream;
  final void Function(String eventId)? onReply;
  final void Function(String eventId)? onActions;
  final void Function(String messageId, String content)? onReact;
  final void Function(String messageId, int amount, String? comment)? onZap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final void Function(String eventId, String reactionImageUrl)? onReactionTap;
  final void Function(String eventId, String amount, String? comment)? onZapTap;

  const AppMessageFeed({
    super.key,
    required this.initialMessages,
    this.messageStream,
    this.reactionStream,
    this.zapStream,
    this.onReply,
    this.onActions,
    this.onReact,
    this.onZap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    required this.onReactionTap,
    required this.onZapTap,
  });

  @override
  State<AppMessageFeed> createState() => _AppMessageFeedState();
}

class _AppMessageFeedState extends State<AppMessageFeed> {
  late final List<Message> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.initialMessages);
    _setupStreams();
  }

  void _setupStreams() {
    widget.messageStream?.listen(_handleNewMessage);
    widget.reactionStream?.listen(_handleNewReaction);
    widget.zapStream?.listen(_handleNewZap);
  }

  void _handleNewMessage(Message message) {
    setState(() {
      _messages.add(message);
      // Create pop-in animation controller for new message
    });
  }

  void _handleNewReaction((String messageId, Reaction reaction) data) {
    setState(() {
      final index = _messages.indexWhere((m) => m.eventId == data.$1);
      if (index != -1) {
        final message = _messages[index];
        _messages[index] = Message(
          eventId: message.eventId,
          content: message.content,
          profileName: message.profileName,
          profilePicUrl: message.profilePicUrl,
          timestamp: message.timestamp,
          reactions: [...message.reactions, data.$2],
          zaps: message.zaps,
        );
      }
    });
  }

  void _handleNewZap((String messageId, Zap zap) data) {
    setState(() {
      final index = _messages.indexWhere((m) => m.eventId == data.$1);
      if (index != -1) {
        final message = _messages[index];
        _messages[index] = Message(
          eventId: message.eventId,
          content: message.content,
          profileName: message.profileName,
          profilePicUrl: message.profilePicUrl,
          timestamp: message.timestamp,
          reactions: message.reactions,
          zaps: [...message.zaps, data.$2],
        );
      }
    });
  }

  // Similar handlers for reactions and zaps

  List<List<Message>> _groupMessages(List<Message> messages) {
    final List<List<Message>> stacks = [];
    List<Message>? currentStack;

    for (final message in messages) {
      if (currentStack == null ||
          currentStack.first.profileName != message.profileName) {
        currentStack = [message];
        stacks.add(currentStack);
      } else {
        currentStack.add(message);
      }
    }
    return stacks;
  }

  @override
  Widget build(BuildContext context) {
    final List<List<Message>> messageStacks = _groupMessages(_messages);
    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < messageStacks.length; i++) ...[
            if (i > 0) const AppGap.s8(),
            AppMessageStack(
              onResolveEvent: widget.onResolveEvent,
              onResolveProfile: widget.onResolveProfile,
              onResolveEmoji: widget.onResolveEmoji,
              onResolveHashtag: widget.onResolveHashtag,
              onLinkTap: widget.onLinkTap,
              profilePicUrl: messageStacks[i].first.profilePicUrl,
              onReply: widget.onReply,
              onActions: widget.onActions,
              onReactionTap: widget.onReactionTap,
              onZapTap: widget.onZapTap,
              messages: messageStacks[i]
                  .map((msg) => MessageData(
                        message: msg.content,
                        profileName: msg.profileName,
                        eventId: msg.eventId,
                        timestamp: msg.timestamp,
                        onReply: widget.onReply,
                        onActions: widget.onActions,
                        reactions: msg.reactions,
                        zaps: msg.zaps,
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
