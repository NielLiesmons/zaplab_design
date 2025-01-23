import 'package:zaplab_design/zaplab_design.dart';

class MessageParser {
  static List<MessageSegment> parse(
      String text, List<QuotedMessage>? quotedMessages) {
    if (quotedMessages == null) return [TextSegment(text)];

    final List<MessageSegment> segments = [];
    final RegExp nostrEventRegex = RegExp(r'nostr:nevent1[a-zA-Z0-9]+');

    final matches = nostrEventRegex.allMatches(text);
    int lastEnd = 0;

    for (final match in matches) {
      // Add text before the quote
      if (match.start > lastEnd) {
        segments.add(TextSegment(text.substring(lastEnd, match.start)));
      }

      // Add the quoted message
      final eventId =
          match.group(0)!.substring(13); // Remove 'nostr:nevent1' prefix
      final quotedMessage = quotedMessages.firstWhere(
        (msg) => msg.eventId == eventId,
        orElse: () => quotedMessages.first,
      );

      segments.add(QuotedMessageSegment(quotedMessage));
      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < text.length) {
      segments.add(TextSegment(text.substring(lastEnd)));
    }

    return segments.isEmpty ? [TextSegment(text)] : segments;
  }
}
