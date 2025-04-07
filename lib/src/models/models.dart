import 'package:flutter/foundation.dart';
import 'package:models/models.dart';

// Event
typedef NostrEventResolver = Future<({Event event, VoidCallback? onTap})>
    Function(String nevent);

String getEventContentType(Event? event) {
  return switch (event) {
    Event<Article>() => 'article',
    Event<ChatMessage>() => 'chat',
    Event<Note>() => 'post',
    Event<App>() => 'app',
    _ => 'nostr',
  };
}

String getEventDisplayText(Event<dynamic>? event) {
  return switch (event) {
    Event<Article>() => (event.internal as Article).title ?? '',
    Event<ChatMessage>() => event.internal.content ?? '',
    Event<Note>() => event.internal.content ?? '',
    Event<App>() => (event.internal as App).name ?? 'App Name',
    _ => '',
  };
}

// Cashu Zap
class CashuZap extends RegularEvent<CashuZap> {
  CashuZap.fromMap(super.map, super.ref) : super.fromMap();

  String get content => internal.content;
  int get amount =>
      int.tryParse(internal.getFirstTagValue('amount') ?? '0') ?? 0;
}

// Communikey
// class Communikey extends ParameterizableReplaceableEvent<Communikey> {
//   Communikey.fromMap(super.map, super.ref) : super.fromMap();

//   String get content => internal.content;
//   Set<String> get contentTypes => internal.getTagSetValues('content-type');
//   String? get location => internal.getFirstTagValue('location');
// }

// class PartialCommunikey
//     extends ParameterizableReplaceablePartialEvent<Communikey> {
//   PartialCommunikey({
//     required String content,
//     required Set<String> contentTypes,
//     String? location,
//   }) {
//     internal.content = content;
//     for (final type in contentTypes) {
//       internal.addTagValue('content-type', type);
//     }
//     if (location != null) {
//       internal.addTagValue('location', location);
//     }
//   }
// }

// Profile
typedef NostrProfileResolver = Future<({Profile profile, VoidCallback? onTap})>
    Function(String npub);
typedef NostrProfileSearch = Future<List<Profile>> Function(String query);

// Emoji
typedef NostrEmojiResolver = Future<String> Function(String identifier);
typedef NostrEmojiSearch = Future<List<ReplaceEmoji>> Function(String query);

class ReplaceEmoji {
  final String emojiUrl;
  final String emojiName;

  const ReplaceEmoji({required this.emojiUrl, required this.emojiName});
}

// Emoj

class Emoji {
  final String? emojiUrl;
  final String emojiName;

  const Emoji({
    this.emojiUrl,
    required this.emojiName,
  });
}

// Hashtag
typedef NostrHashtagResolver = Future<void Function()?> Function(
    String identifier);

// Links
typedef LinkTapHandler = void Function(String url);
