import 'package:zaplab_design/zaplab_design.dart';

class Message {
  final String eventId;
  final String content;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;
  final List<Reaction> reactions;
  final List<Zap> zaps;
  final List<QuotedMessage>? quotedMessages;

  const Message({
    required this.eventId,
    required this.content,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
    this.reactions = const [],
    this.zaps = const [],
    this.quotedMessages,
  });
}

class Reaction {
  final String emojiUrl;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;

  const Reaction({
    required this.emojiUrl,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
  });
}

class Zap {
  final int amount;
  final String profileName;
  final String profilePicUrl;
  final String? comment;
  final DateTime timestamp;

  const Zap({
    required this.amount,
    required this.profileName,
    required this.profilePicUrl,
    this.comment,
    required this.timestamp,
  });
}

class AppMessageFeed extends StatefulWidget {
  final List<Message> initialMessages;
  final Stream<Message>? messageStream;
  final Stream<(String messageId, Reaction reaction)>? reactionStream;
  final Stream<(String messageId, Zap zap)>? zapStream;
  final void Function(String eventId)? onReply;
  final void Function(String eventId)? onActions;
  final void Function(String messageId, String content)? onReact;
  final void Function(String messageId, int amount, String? comment)? onZap;

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
          quotedMessages: message.quotedMessages,
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
          quotedMessages: message.quotedMessages,
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
              profilePicUrl: messageStacks[i].first.profilePicUrl,
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
                        quotedMessages: msg.quotedMessages,
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
