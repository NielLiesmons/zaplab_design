import 'package:zaplab_design/zaplab_design.dart';

enum ShortTextSegmentType {
  text,
  profileMention,
  hashtag,
  quotedMessage,
  quotedPost,
  url
}

class ShortTextSegment {
  final ShortTextSegmentType type;
  final String content;
  final Map<String, dynamic>? metadata;

  const ShortTextSegment({
    required this.type,
    required this.content,
    this.metadata,
  });
}

class ShortTextParser {
  static List<ShortTextSegment> parse(String text) {
    // For now, return the entire text as a single segment
    return [
      ShortTextSegment(
        type: ShortTextSegmentType.text,
        content: text,
      )
    ];
  }
}
