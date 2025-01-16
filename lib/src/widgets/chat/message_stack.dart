import 'package:zaplab_design/zaplab_design.dart';

class AppMessageStack extends StatelessWidget {
  final String profilePicUrl;
  final List<MessageData> messages;

  const AppMessageStack({
    super.key,
    required this.profilePicUrl,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppContainer(
          child: AppProfilePic.s24(profilePicUrl),
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
                    onActions: (eventId) =>
                        messages[i].onActions?.call(eventId),
                    onReply: (eventId) => messages[i].onReply?.call(eventId),
                  ),
                ],
              ],
            ),
          ),
        ),
        const AppGap.s20(),
        const AppGap.s8(),
      ],
    );
  }
}

class MessageData {
  final String message;
  final String profileName;
  final DateTime timestamp;
  final String eventId;
  final void Function(String)? onReply;
  final void Function(String)? onActions;

  const MessageData({
    required this.message,
    required this.profileName,
    required this.timestamp,
    required this.eventId,
    this.onReply,
    this.onActions,
  });
}
