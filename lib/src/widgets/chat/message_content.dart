import 'package:zaplab_design/zaplab_design.dart';

class AppMessageContent extends StatelessWidget {
  final String content;
  final List<QuotedMessage>? quotedMessages;

  const AppMessageContent({
    super.key,
    required this.content,
    this.quotedMessages,
  });

  List<Widget> _buildContent(BuildContext context, String text) {
    final theme = AppTheme.of(context);
    final List<Widget> widgets = [];
    final segments = MessageParser.parse(text, quotedMessages);

    for (final segment in segments) {
      if (segment is TextSegment) {
        widgets.add(AppSelectableText(
          text: segment.text,
          style: segment.style ??
              theme.typography.reg14.copyWith(
                color: theme.colors.white,
              ),
        ));
      } else if (segment is QuotedMessageSegment) {
        widgets.add(AppQuotedMessage(
          profileName: segment.message.profileName,
          profilePicUrl: segment.message.profilePicUrl,
          content: segment.message.content,
          timestamp: segment.message.timestamp,
          eventId: segment.message.eventId,
        ));
      } // Handle other segments
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildContent(context, content),
    );
  }
}
