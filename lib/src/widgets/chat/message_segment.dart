import 'package:zaplab_design/zaplab_design.dart';

abstract class MessageSegment {}

class TextSegment extends MessageSegment {
  final String text;
  final TextStyle? style;

  TextSegment(this.text, {this.style});
}

class ProfileMentionSegment extends MessageSegment {
  final String npub;
  final String displayName;

  ProfileMentionSegment(this.npub, this.displayName);
}

class HashtagSegment extends MessageSegment {
  final String tag;
  HashtagSegment(this.tag);
}

class QuotedMessageSegment extends MessageSegment {
  final QuotedMessage message;
  QuotedMessageSegment(this.message);
}

// TODO: Add more segment types