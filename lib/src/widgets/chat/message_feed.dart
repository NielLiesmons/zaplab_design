import 'package:zaplab_design/zaplab_design.dart';

class Message {
  final String eventId;
  final String content;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;
  final List<Reaction> reactions;
  final List<Zap> zaps;

  const Message({
    required this.eventId,
    required this.content,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
    this.reactions = const [],
    this.zaps = const [],
  });
}

class Reaction {
  final String content;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;

  const Reaction({
    required this.content,
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

class AppMessageFeed extends StatelessWidget {
  final List<Message> messages;
  final void Function(String eventId)? onReply;
  final void Function(String eventId)? onActions;

  const AppMessageFeed({
    super.key,
    required this.messages,
    this.onReply,
    this.onActions,
  });

  @override
  Widget build(BuildContext context) {
    final List<List<Message>> messageStacks = _groupMessages(messages);

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s8),
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
                        onReply: onReply,
                        onActions: onActions,
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  List<List<Message>> _groupMessages(List<Message> messages) {
    final List<List<Message>> stacks = [];
    List<Message>? currentStack;

    for (final message in messages) {
      if (currentStack == null ||
          !_shouldAddToStack(currentStack.last, message)) {
        currentStack = [message];
        stacks.add(currentStack);
      } else {
        currentStack.add(message);
      }
    }

    return stacks;
  }

  bool _shouldAddToStack(Message last, Message current) {
    return last.profileName == current.profileName &&
        current.timestamp.difference(last.timestamp).inMinutes < 5;
  }
}
